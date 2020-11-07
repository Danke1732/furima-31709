FactoryBot.define do
  factory :item do
    name { "MyString" }
    description { "MyText" }
    category_id { 1 }
    status_id { 1 }
    shipping_id { 1 }
    prefecture_id { 1 }
    transport_days_id { 1 }
    user { nil }
  end
end
