require 'rails_helper'

RSpec.describe "Merchants API" do
  it "sends a list of merchants from /merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants).to have_key(:data)
    expect(merchants[:data]).to be_an Array

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a String

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a String
      
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a Hash

      attributes = merchant[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a String
    end
  end

  it "sends a single merchants details from /merchants/:id" do
    create_list(:merchant, 3)
    primary_merchant = Merchant.create!(name: "Primary Merchant")

    get "/api/v1/merchants/#{primary_merchant.id}"

    expect(response).to be_successful
    merchant = JSON.parse(response.body)

    expect(merchant).to have_key("data")
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

  it "sends a list of a merchant's items from /merchants/:id/items" do
    merchant = Merchant.create!(name: "Primary Merchant")
    create_list(:item, 5, merchant_id: merchant.id)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body)
    expect(items).to have_key("data")
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

  it "can find a single merchant given a search term" do
    merchant = Merchant.create!(name: "mY SeARch MERchanT")
    create_list(:merchant, 15)

    get "/api/v1/merchants/find?name=search"

    expect(response).to be_successful
    
    result = JSON.parse(response.body)
    expect(result).to have_key("data")
    expect(result["data"]).to be_a Hash

    data = result["data"]
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
end