class Item < ApplicationRecord
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  belongs_to :merchant

  def self.find_all_by_name(name)
    Item.where("name ilike ?", "%" + Item.sanitize_sql_like(name) + "%")
        .order("name")
  end
end