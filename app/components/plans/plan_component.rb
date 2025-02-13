# frozen_string_literal: true

module Plans
  class PlanComponent < ViewComponent::Base
    delegate :name, :description, :charge_per_unit?, :unit_label, to: :plan
    attr_reader :plan

    def custom?
      plan.contact_url.present?
    end

    def background_classes
      if custom?
        'bg-gray-900 ring-gray-900'
      else
        'bg-white ring-gray-200'
      end
    end

    def title_color
      if custom?
        'text-white'
      else
        'text-gray-900'
      end
    end

    def text_color
      if custom?
        'text-gray-300'
      else
        'text-gray-600'
      end
    end

    def check_color
      if custom?
        'text-white'
      else
        'text-indigo-600'
      end
    end

    def plan_url
      if custom?
        plan.contact_url
      else
        new_plan_subscription_path(plan)
      end
    end

    def initialize(plan:)
      super

      @plan = plan
    end

    def trial?
      Current.account.subscription.blank? && plan.trial?
    end

    def current_plan?
      plan == Current.account.plan
    end

    def subscribed?
      Current.account.subscribed?
    end

    def features
      plan_features = plan.features

      plan_features.unshift("Free #{plan.trial_period_days}-day trial") if trial?

      plan_features
    end

    def amount
      if custom?
        'Custom'
      else
        number_to_currency(plan.amount / 100.0)
      end
    end

    def interval
      case plan.interval
      when 'monthly' then 'month'
      when 'yearly' then 'year'
      end
    end
  end
end
