class Item < ApplicationRecord
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  belongs_to :merchant

  def self.by_merchant(id)
    Item.where("merchant_id = ?", id)
  end
end