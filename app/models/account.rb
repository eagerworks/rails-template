class Account < ApplicationRecord
  has_many :account_users, dependent: :destroy
  has_many :users, through: :account_users
  has_many :account_invitations, dependent: :destroy
  has_one :subscription, dependent: :destroy
  has_one :plan, through: :subscription

  belongs_to :owner, class_name: 'User'

  validates :name, presence: true, uniqueness: { scope: :owner_id }

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [32, 32], preprocessed: true
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[name owner_id]
  end

  def subscribed?(name: nil)
    subscription.present? && (subscription.active? || subscription.on_grace_period?) &&
      (name.blank? || subscription.plan_name == name)
  end
end
