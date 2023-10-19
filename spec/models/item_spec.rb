require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    
    it { should belong_to :merchant }
  end

  describe "class methods" do
    before(:each) do
      @merchant = Merchant.create!(name: "Kiwi")
      @item1 = Item.create!(name: "a searchable One", description: "a searchable item", unit_price: 1023, merchant_id: @merchant.id)
      @item2 = Item.create!(name: "c SEARCHAble Two", description: "a searchable item", unit_price: 1, merchant_id: @merchant.id)
      @item3 = Item.create!(name: "b SeARchable Three", description: "a searchable item", unit_price: 23, merchant_id: @merchant.id)
      @item4 = Item.create!(name: "d No match one", description: "a non-searchable item", unit_price: 50.40, merchant_id: @merchant.id)
      @item5 = Item.create!(name: "e no match TWO", description: "a non-searchable item", unit_price: 10943.2, merchant_id: @merchant.id)
    end
    describe "#find_all_by_name" do
      it "returns all items with a name alike the given argument" do
        expect(Item.find_all_by_name("search")).to eq([@item1, @item3, @item2])
      end
    end

    describe "#find_all_by_price_range" do
      it "returns all items within a min and max price range" do
        expect(Item.find_all_by_price_range(10, 100)).to eq([@item3, @item4])
      end
    end

    describe "#find_all_by_min_price" do
      it "returns all items over a given price threshold" do
        expect(Item.find_all_by_min_price(50)).to eq([@item1, @item4, @item5])
      end
    end

    describe "#find_all_by_max_price" do
      it "returns all items under a given price threshold" do
        expect(Item.find_all_by_max_price(50)).to eq(@item3, @item2)
      end
    end
  end
end