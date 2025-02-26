class Credential < ApplicationRecord
  belongs_to :user

  validates :webauthn_id, presence: true, uniqueness: true
  validates :public_key, :name, presence: true
end
