FactoryBot.define do
  factory :plan do
    name { Faker::Commerce.product_name }
    amount { Faker::Number.number(digits: 4) }
  end
end
