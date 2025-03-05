FactoryBot.define do
  factory :active_admin_comment, class: ActiveAdmin::Comment do
    namespace { 'admin' }
    body { Faker::Lorem.sentence }
    author { create(:user) }
    resource { create(:account) }
  end
end
