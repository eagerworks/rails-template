class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :account

  validates :stripe_id, presence: true
  validates :ends_at, presence: true, if: :canceled?

  delegate :name, to: :plan, prefix: true

  enum :status, { active: 0, canceled: 1 }

  def on_grace_period?
    canceled? && ends_at > Time.current
  end
end
