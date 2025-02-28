FactoryBot.define do
  factory :credential do
    user
    webauthn_id { SecureRandom.base64(32) }
    public_key { SecureRandom.base64(32) }
    name { Faker::Device.model_name }
  end
end
