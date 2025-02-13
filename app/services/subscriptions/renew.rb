module Subscriptions
  class Renew < ApplicationService
    def call(subscription:)
      if subscription.ends_at && subscription.ends_at < Time.current
        return failure('Subscription has already ended.')
      end

      Stripe::Subscription.update(subscription.stripe_id,
                                  { cancel_at_period_end: false })
      subscription.update!(status: :active, ends_at: nil)
      success(subscription)
    end
  end
end
