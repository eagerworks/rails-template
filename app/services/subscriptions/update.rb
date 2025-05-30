module Subscriptions
  class Update
    include Interactor

    def call
      update_stripe_plan

      context.subscription.update!(udpate_params)
      notify_user
    end

    private

    def notify_user
      NewSubscriptionNotifier.with(subscription: context.subscription)
                             .deliver(context.subscription.account.users)
    end

    def udpate_params
      context.params.merge(trial_ends_at: trial_end, status: context.stripe_subscription.status)
    end

    def update_stripe_plan
      context.stripe_subscription = Stripe::Subscription.update(
        context.subscription.stripe_id,
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

      context.subscription.created_at + plan.trial_period_days.days
    end

    def plan
      context.plan ||= Plan.find(context.params[:plan_id])
    end

    def subscription_item
      context.subscription_item ||= Stripe::SubscriptionItem.list(
        subscription: context.subscription.stripe_id
      ).data.first
    end
  end
end
