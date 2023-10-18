require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    
    it { should belong_to :merchant }
  end

  describe "class methods" do
    before(:each) do
      @merchant1 = Merchant.create!(name: "Kiwi Merchant")
      @merchant2 = Merchant.create!(name: "Chicken Merchant")
      create_list(:item, 3, merchant_id: @merchant1.id)
      create_list(:item, 2, merchant_id: @merchant2.id)
    end

    describe "#by_merchant" do
      it "returns all items associated to a merchant via merchant ID" do
        items = Item.by_merchant(@merchant1.id)

        expect(items.first).to be_an Item
        expect(items.count).to eq(3)
      end
    end
  end
end