FactoryBot.define do
  factory :account do
    owner { create(:user) }
    name { Faker::Company.name }

    trait :with_user do
      transient do
        user { create(:user) }
      end

      after(:create) do |account, evaluator|
        create(:account_user, account: account, user: evaluator.user)
      end
    end

    trait :with_subscription do
      after(:create) do |account|
        create(:subscription, account: account)
      end
    end
  end
end
