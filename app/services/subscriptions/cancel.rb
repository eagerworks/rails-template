module Subscriptions
  class Cancel < ApplicationService
    def call(subscription)
      api_record = Stripe::Subscription.update(subscription.stripe_id,
                                               { cancel_at_period_end: true })
      subscription.update!(status: :canceled, ends_at: Time.at(api_record.current_period_end))
      success(subscription)
    end
  end
end
