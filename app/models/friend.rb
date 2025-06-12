class Friend < ApplicationRecord
  belongs_to :user

  enum :gender, { male: 0, female: 1, other: 2 }

  validates :name, :description, :birth_date, :awards, :height, :gender, presence: true
end
