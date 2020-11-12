FactoryBot.define do
  factory :transaction do
    postal_code { '123-4567' }
    prefecture_id { Faker::Number.within(range: 2..48) }
    city { Gimei.city.kanji }
    address { Faker::Address.building_number }
    building { 'マンション111-1' }
    phone_num { '09012345678' }
    token     { 'tok_abcdefghijk00000000000000000' }
    user_id     { Faker::Number.number(digits: 8) }
    item_id     { Faker::Number.number(digits: 8) }
  end
end
