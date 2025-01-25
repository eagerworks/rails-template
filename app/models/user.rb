class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :confirmable

  validates :full_name, presence: true

  has_many :account_users, dependent: :destroy
  has_many :accounts, through: :account_users
  has_many :owned_accounts, class_name: 'Account', foreign_key: :owner_id, dependent: :destroy

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [32, 32], preprocessed: true
  end

  def create_default_account
    account = Account.create!(name: full_name, owner: self, personal: true)
    account_users.create!(account: account, role: :admin)
    account
  end

  def multi_account?
    accounts.count > 1
  end
end
