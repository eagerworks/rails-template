class Plan < ApplicationRecord
  validates_presence_of :name, :amount
  validates :currency, presence: true, format: {
    with: /\A[a-zA-Z]{3}\z/, message: 'must be a 3-letter ISO currency code'
  }
  validates :unit_label, presence: { if: :charge_per_unit? }

  scope :published, -> { where(private: false) }

  normalizes :currency, with: lambda(&:downcase)

  enum :interval, { monthly: 0, yearly: 1 }

  store_accessor :details, :features

  has_many :subscriptions

  def self.ransackable_attributes(_auth_object = nil)
    %w[name amount interval currency]
  end

  def features
    Array.wrap(super)
  end

  def formatted_features
    features.join("\n")
  end

  def formatted_features=(value)
    self.features = value.split("\n").map(&:strip)
  end

  def trial?
    trial_period_days.positive?
  end

  def stripe?
    stripe_id.present?
  end
end
