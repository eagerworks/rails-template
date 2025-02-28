FactoryBot.define do
  factory :account_invitation do
    account
    invited_by { create(:user) }
    email { Faker::Internet.email }
    name { Faker::Name.name }
  end
end
