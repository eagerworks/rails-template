module Subscriptions
  class Cancel
    include Interactor

    def call
      api_record = Stripe::Subscription.update(
        context.subscription.stripe_id,
        { cancel_at_period_end: true }
      )
      context.subscription.update!(
        status: :canceled, ends_at: Time.at(api_record.current_period_end)
      )
    end
  end
end
