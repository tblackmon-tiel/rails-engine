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
    expect(attributes).to have_key("description")
    expect(attributes["description"]).to be_a String
    expect(attributes).to have_key("unit_price")
    expect(attributes["unit_price"]).to be_a Numeric
  end
end