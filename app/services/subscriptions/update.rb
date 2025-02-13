module Subscriptions
  class Update < ApplicationService
    def call(subscription:, params:)
      @subscription = subscription
      @params = params

      update_stripe_plan

      @subscription.update!(udpate_params)

      success(@subscription)
    end

    def udpate_params
      @params.merge(trial_ends_at: trial_end, status: @stripe_subscription.status)
    end

    def update_stripe_plan
      @stripe_subscription = Stripe::Subscription.update(
        @subscription.stripe_id,
        {
          items: [
            {
              id: subscription_item.id,
              price: plan.stripe_id
            }
          ],
          trial_end: trial_end&.to_i || 'now'
        }
      )
    end

    def trial_end
      return nil unless plan.trial?

      @subscription.created_at + plan.trial_period_days.days
    end

    def plan
      @plan ||= Plan.find(@params[:plan_id])
    end

    def subscription_item
      @subscription_item ||= Stripe::SubscriptionItem.list(subscription: @subscription.stripe_id)
                                                     .data.first
    end
  end
end
