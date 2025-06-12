FactoryBot.define do
  factory :friend do
    name { "MyString" }
    description { "MyText" }
    birth_date { "2025-06-11" }
    user { nil }
    best_friend { false }
    awards { 1 }
    height { 1.5 }
    gender { 1 }
  end
end
