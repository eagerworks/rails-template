class Credential < ApplicationRecord
  belongs_to :user

  validates :webauthn_id, presence: true, uniqueness: true
end
