FactoryBot.define do
  factory :account do
    owner { create(:user) }
    name { Faker::Company.name }

    trait :with_subscription do
      after(:create) do |account|
        create(:subscription, account: account)
      end
    end
  end
end
