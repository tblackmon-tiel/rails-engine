require 'rails_helper'

RSpec.describe "Items API" do
  it "returns a list of items from /items" do
    merchant = Merchant.create!(name: "Kiwi")
    create_list(:item, 10, merchant_id: merchant.id)

    get "/api/v1/items"
    expect(response).to be_successful

    items = JSON.parse(response.body)
    expect(items["data"]).to be_an Array

    items["data"].each do |item|
      expect(item).to have_key("id")
      expect(item["id"]).to be_a String

      expect(item).to have_key("type")
      expect(item["type"]).to be_a String
      
      expect(item).to have_key("attributes")
      expect(item["attributes"]).to be_a Hash

      attributes = item["attributes"]

      expect(attributes).to have_key("name")
      expect(attributes["name"]).to be_a String
      expect(attributes).to have_key("description")
      expect(attributes["description"]).to be_a String
      expect(attributes).to have_key("unit_price")
      expect(attributes["unit_price"]).to be_a Numeric
      expect(attributes).to have_key("merchant_id")
      expect(attributes["merchant_id"]).to be_a Numeric
    end
  end

  it "returns a single item from /items/:id" do
    merchant = Merchant.create!(name: "Kiwi")
    create_list(:item, 10, merchant_id: merchant.id)
    item = Item.create!(name: "Test Item", description: "just a test", unit_price: 20.32, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}"
    expect(response).to be_successful

    details = JSON.parse(response.body)
    expect(details["data"]).to be_a Hash

    item = details["data"]

    expect(item).to have_key("id")
    expect(item["id"]).to be_a String

    expect(item).to have_key("type")
    expect(item["type"]).to be_a String
    
    expect(item).to have_key("attributes")
    expect(item["attributes"]).to be_a Hash

    attributes = item["attributes"]

    expect(attributes).to have_key("name")
    expect(attributes["name"]).to be_a String
    expect(attributes).to have_key("description")
    expect(attributes["description"]).to be_a String
    expect(attributes).to have_key("unit_price")
    expect(attributes["unit_price"]).to be_a Numeric
    expect(attributes).to have_key("merchant_id")
    expect(attributes["merchant_id"]).to be_a Numeric
  end

  it "allows creation of an item through posting to /items" do
    merchant = Merchant.create!(name: "Kiwi")
    item_params = {
      name: "New Item",
      description: "An item created via API",
      unit_price: 78.26,
      merchant_id: merchant.id
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item_params)
    expect(response).to be_successful

    item = Item.last

    expect(item.name).to eq(item_params[:name])
    expect(item.description).to eq(item_params[:description])
    expect(item.unit_price).to eq(item_params[:unit_price])
    expect(item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "allows deletion of an item through deleting to /items/:id" do
    merchant = Merchant.create!(name: "Kiwi")
    item = Item.create!(name: "Test item", description: "I'm in danger!", unit_price: 1.01, merchant_id: merchant.id)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end