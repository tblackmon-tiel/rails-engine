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

  it "returns 404 on an id that doesn't exist" do
    get "/api/v1/items/999999999"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)
    expect(data[:errors]).to be_an Array
    expect(data[:errors].first[:status]).to eq(404)
    expect(data[:errors].first[:title]).to eq("Couldn't find Item with 'id'=999999999")
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

  it "can update an existing item" do
    merchant = Merchant.create!(name: "Kiwi")
    id = create(:item, merchant_id: merchant.id).id
    item_params = { name: "Updated Item", description: "new description", unit_price: 1023.23 }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)
  
    expect(response).to be_successful
    expect(item.name).to eq("Updated Item")
    expect(item.description).to eq("new description")
    expect(item.unit_price).to eq(1023.23)
  end

  it "can provide the merchant for a given item" do
    merchant = Merchant.create!(name: "Kiwi")
    id = create(:item, merchant_id: merchant.id).id

    get "/api/v1/items/#{id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)
    expect(merchant["data"]).to be_a Hash

    data = merchant["data"]
    expect(data).to have_key("id")
    expect(data["id"]).to be_a String
    expect(data).to have_key("type")
    expect(data["type"]).to be_a String
    expect(data).to have_key("attributes")
    expect(data["attributes"]).to be_a Hash

    attributes = data["attributes"]
    expect(attributes).to have_key("name")
    expect(attributes["name"]).to be_a String
  end

  it "can find all items by a given name" do
    merchant = Merchant.create!(name: "Kiwi")
    item1 = Item.create!(name: "searchable One", description: "a searchable item", unit_price: 1023, merchant_id: merchant.id)
    item2 = Item.create!(name: "SEARCHAble Two", description: "a searchable item", unit_price: 1, merchant_id: merchant.id)
    item3 = Item.create!(name: "SeARchable Three", description: "a searchable item", unit_price: 23, merchant_id: merchant.id)
    item4 = Item.create!(name: "No match one", description: "a non-searchable item", unit_price: 50.40, merchant_id: merchant.id)
    item5 = Item.create!(name: "no match TWO", description: "a non-searchable item", unit_price: 10943.2, merchant_id: merchant.id)

    get "/api/v1/items/find_all?name=search"
    expect(response).to be_successful

    items = JSON.parse(response.body)
    expect(items).to have_key("data")
    expect(items["data"]).to be_an Array
    expect(items["data"].count).to eq(3)

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

  it "can find all items by a given min price" do
    merchant = Merchant.create!(name: "Kiwi")
    item1 = Item.create!(name: "searchable One", description: "a searchable item", unit_price: 1023, merchant_id: merchant.id)
    item2 = Item.create!(name: "SEARCHAble Two", description: "a searchable item", unit_price: 1, merchant_id: merchant.id)
    item3 = Item.create!(name: "SeARchable Three", description: "a searchable item", unit_price: 23, merchant_id: merchant.id)
    item4 = Item.create!(name: "No match one", description: "a non-searchable item", unit_price: 50.40, merchant_id: merchant.id)
    item5 = Item.create!(name: "no match TWO", description: "a non-searchable item", unit_price: 10943.2, merchant_id: merchant.id)
  
    get "/api/v1/items/find_all?min_price=50"
    expect(response).to be_successful
  
    items = JSON.parse(response.body)
    expect(items).to have_key("data")
    expect(items["data"]).to be_an Array
    expect(items["data"].count).to eq(3)
  
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

  it "can find all items by a given max price" do
    merchant = Merchant.create!(name: "Kiwi")
    item1 = Item.create!(name: "searchable One", description: "a searchable item", unit_price: 1023, merchant_id: merchant.id)
    item2 = Item.create!(name: "SEARCHAble Two", description: "a searchable item", unit_price: 1, merchant_id: merchant.id)
    item3 = Item.create!(name: "SeARchable Three", description: "a searchable item", unit_price: 23, merchant_id: merchant.id)
    item4 = Item.create!(name: "No match one", description: "a non-searchable item", unit_price: 50.40, merchant_id: merchant.id)
    item5 = Item.create!(name: "no match TWO", description: "a non-searchable item", unit_price: 10943.2, merchant_id: merchant.id)
  
    get "/api/v1/items/find_all?max_price=50"
    expect(response).to be_successful
  
    items = JSON.parse(response.body)
    expect(items).to have_key("data")
    expect(items["data"]).to be_an Array
    expect(items["data"].count).to eq(2)
  
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
end