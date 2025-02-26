class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[google_oauth2 facebook]

  validates :full_name, presence: true

  has_many :account_users, dependent: :destroy
  has_many :accounts, through: :account_users
  has_many :owned_accounts, class_name: 'Account', foreign_key: :owner_id, dependent: :destroy
  has_many :credentials, dependent: :destroy

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

  def two_factor_enabled?
    credentials.any?
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[email full_name admin]
  end

  def self.from_omniauth(auth)
    user = find_from_omniauth(auth)
    return user if user.present?

    create(
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      password: Devise.friendly_token[0, 20],
      full_name: auth.info.name,
      confirmed_at: Time.zone.now,
      password_set: false
    )
  end

  def self.find_from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user.present?

    user = find_by(email: auth.info.email)
    user.update(provider: auth.provider, uid: auth.uid) if user.present?
    user
  end
end
