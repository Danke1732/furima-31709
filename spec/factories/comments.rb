FactoryBot.define do
  factory :comment do
    text { "MyText" }
    user { nil }
    item { nil }
  end
end
