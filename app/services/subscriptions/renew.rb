module Subscriptions
  class Renew
    include Interactor

    def call
      if context.subscription.ends_at && context.subscription.ends_at < Time.current
        context.fail!(error: 'Subscription has already ended.')
      end

      update_subscription
    end

    private

    def update_subscription
      Stripe::Subscription.update(
        context.subscription.stripe_id, { cancel_at_period_end: false }
      )

      context.subscription.update!(status: :active, ends_at: nil)
    end
  end
end
