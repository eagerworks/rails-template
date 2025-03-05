FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    confirmed_at { Time.zone.now } # Confirm the user by default

    trait :admin do
      admin { true }
    end
  end
end
