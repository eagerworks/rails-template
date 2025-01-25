class Account < ApplicationRecord
  has_many :account_users, dependent: :destroy
  has_many :users, through: :account_users

  belongs_to :owner, class_name: 'User'

  validates :name, presence: true

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [32, 32], preprocessed: true
  end
end
