class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :unit_price
  
  attribute :merchant_id do |item|
    item.merchant_id.to_s
  end
end
