require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :invoices }
    it { should have_many :items }
  end

  describe "class methods" do
    describe "#find_by_name" do
      it "returns the first merchant, alphabetically, with an alike name case insensitive" do
        merchant = Merchant.create!(name: "mY SeARch MERchanT")
        create_list(:merchant, 15)

        expect(Merchant.find_by_name("search")).to eq(merchant)
      end

      it "handles multiple similar results" do
        merchant1 = Merchant.create!(name: "Kiwibird")
        merchant2 = Merchant.create!(name: "A kiwi bird")
        merchant3 = Merchant.create!(name: "Ckiwi")

        expect(Merchant.find_by_name("KIWI")).to eq(merchant2)
      end
    end
  end
end