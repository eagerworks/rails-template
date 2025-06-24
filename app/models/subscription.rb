class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :account

  validates :stripe_id, presence: true
  validates :ends_at, presence: true, if: :canceled?
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }

  delegate :name, to: :plan, prefix: true

  enum :status, { active: 0, canceled: 1, paused: 2 }

  def on_grace_period?
    !active? && ends_at > Time.current
  end
end
