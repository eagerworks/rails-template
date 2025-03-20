class AccountUser < ApplicationRecord
  belongs_to :account
  belongs_to :user

  delegate :avatar, to: :user
  delegate :full_name, to: :user
  delegate :email, to: :user

  enum :role, { member: 0, admin: 1 }

  validates :role, presence: true

  def owner?
    account.owner_id == user_id
  end
end
