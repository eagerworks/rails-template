FactoryBot.define do
  factory :account_user do
    account
    user

    trait :owner do
      account { create(:account, :with_user, user: user, owner: user) }
      role { :admin }
    end
  end
end
