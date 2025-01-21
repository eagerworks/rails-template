class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :confirmable

  validates :full_name, presence: true

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [32, 32], preprocessed: true
  end
end
