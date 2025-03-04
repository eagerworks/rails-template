FactoryBot.define do
  factory :subscription do
    account
    plan
    quantity { 1 }
    stripe_id { "sub_#{Faker::Alphanumeric.alphanumeric(number: 10)}" }

    trait :on_grace_period do
      status { :canceled }
      ends_at { 1.day.from_now }
    end

    trait :ended do
      status { :canceled }
      ends_at { 1.day.ago }
    end
  end
end
