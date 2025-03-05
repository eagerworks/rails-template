FactoryBot.define do
  factory :plan do
    name { Faker::Commerce.product_name }
    amount { Faker::Number.number(digits: 4) }

    trait :trial do
      trial_period_days { rand(1..30) }
    end

    trait :published do
      private { false }
    end

    trait :private do
      private { true }
    end
  end
end
