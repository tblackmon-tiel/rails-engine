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
end