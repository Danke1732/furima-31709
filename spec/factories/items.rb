FactoryBot.define do
  factory :item do
    name {Faker::Name.last_name}
    description {Faker::Lorem.sentence}
    category_id {Faker::Number.within(range: 2..11)}
    status_id {Faker::Number.within(range: 2..7)}
    shipping_id {Faker::Number.within(range: 2..3)}
    prefecture_id {Faker::Number.within(range: 2..48)}
    transportday_id {Faker::Number.within(range: 2..4)}
    price {Faker::Number.within(range: 300..9999999)}
    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test-image.png'), filename: 'test-image.png')
    end
  end
end
