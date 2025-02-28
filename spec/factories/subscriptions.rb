FactoryBot.define do
  factory :subscription do
    account
    plan
    quantity { 1 }
    stripe_id { "sub_#{Faker::Alphanumeric.alphanumeric(number: 10)}" }
  end
end
