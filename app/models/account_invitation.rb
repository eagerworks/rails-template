class AccountInvitation < ApplicationRecord
  belongs_to :account
  belongs_to :invited_by, class_name: 'User'

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :email, uniqueness: {
    scope: :account_id, message: 'has already been invited', case_sensitive: false
  }

  has_secure_token

  enum :role, { member: 0, admin: 1 }

  def to_param
    token
  end
end
