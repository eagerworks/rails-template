class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum type: { admin: 0, developer: 1, office_manager: 2, comunications: 3, client: 4 }
  has_many :user_skills, dependent: :destroy
  has_many :skills,  through: :user_skills
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :type, presence: true
end
