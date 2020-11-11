FactoryBot.define do
  factory :destination do
    postal_code { Faker::Address.postcode }
    prefecture_id { Faker::Number.within(range: 2..48) }
    city { Gimei.city.kanji }
    address { Faker::Address.building_number }
    building { "マンション111-1" }
    phone_num { Faker::PhoneNumber.cell_phone }
    association :buyer
  end
end
