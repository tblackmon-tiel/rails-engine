class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  def self.find_by_name(name)
    Merchant.where("name ilike ?", "%" + Merchant.sanitize_sql_like(name) + "%")
            .order("name")
            .take
  end
end