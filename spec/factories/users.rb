FactoryBot.define do
  factory :user do
    nickname      { Faker::Name.last_name }
    email         { Faker::Internet.free_email }
    password      { Faker::Internet.password(min_length: 15) }
    password_confirmation { password }
    last_name     { Gimei.last.kanji }
    first_name    { Gimei.first.kanji }
    last_name_katakana { Gimei.last.katakana }
    first_name_katakana { Gimei.first.katakana }
    birth_date { Faker::Date.in_date_period }
  end

  factory :user_test, class: User do
    nickname      { Faker::Name.last_name }
    email         { Faker::Internet.free_email }
    password      { "aaa111" }
    password_confirmation { password }
    last_name     { Gimei.last.kanji }
    first_name    { Gimei.first.kanji }
    last_name_katakana { Gimei.last.katakana }
    first_name_katakana { Gimei.first.katakana }
    birth_date { Faker::Date.in_date_period }
  end

  factory :user_test2, class: User do
    nickname      { Faker::Name.last_name }
    email         { Faker::Internet.free_email }
    password      { "111aaa" }
    password_confirmation { password }
    last_name     { Gimei.last.kanji }
    first_name    { Gimei.first.kanji }
    last_name_katakana { Gimei.last.katakana }
    first_name_katakana { Gimei.first.katakana }
    birth_date { Faker::Date.in_date_period }
  end
end
