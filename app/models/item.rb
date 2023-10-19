class Item < ApplicationRecord
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  belongs_to :merchant

  def self.find_all_by_name(name)
    Item.where("name ilike ?", "%" + Item.sanitize_sql_like(name) + "%")
        .order("name")
  end

  def self.find_all_by_price_range(min, max)
    Item.where("unit_price >= ? and unit_price <= ?", min, max)
        .order("name")
  end

  def self.find_all_by_min_price(min)
    Item.where("unit_price >= ?", min)
        .order("name")
  end

  def self.find_all_by_max_price(max)
    Item.where("unit_price <= ?", max)
        .order("name")
  end
end