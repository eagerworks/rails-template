FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at { Time.zone.now } # Confirm the user by default

    trait :admin do
      admin { true }
    end

    trait :with_account do
      after(:create) do |user|
        account = create(:account, owner: user)
        create(:account_user, account: account, user: user, role: :admin)
      end
    end
  end
end
