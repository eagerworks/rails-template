module Subscriptions
  class BaseComponent < ViewComponent::Base
    attr_reader :subscription

    delegate :plan, :canceled?, :active?, :on_grace_period?, :paused?, to: :subscription
    delegate :name, to: :plan, prefix: true
    delegate :charge_per_unit?, :unit_label, to: :plan

    def initialize(subscription:)
      super

      @subscription = subscription
    end

    def amount
      number_to_currency(plan.amount / 100.0)
    end

    def trial?
      subscription.trial_ends_at.present?
    end

    def interval
      case plan.interval
      when 'monthly' then 'month'
      when 'yearly' then 'year'
      end
    end
  end
end
