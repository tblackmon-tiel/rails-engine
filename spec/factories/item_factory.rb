FactoryBot.define do
  factory :item do
    name { Faker::Appliance.equipment }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Number.decimal(l_digits: 2) }
    merchant_id { "1" }
  end
end