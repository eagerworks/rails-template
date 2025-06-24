module Stripe
  class HandleWebhook
    include Interactor

    def call
      return unless event_types.include?(context.event.type)

      update_subscription
    end

    private

    def event_types
      %w[deleted paused resumed].map do |action|
        "customer.subscription.#{action}"
      end
    end

    def stripe_subscription
      context.event.data.object
    end

    def update_subscription
      subscription = ::Subscription.find_by!(stripe_id: stripe_subscription.id)

      ends_at = if context.event.type == 'customer.subscription.resumed'
                  nil
                else
                  Time.at(stripe_subscription.current_period_end)
                end

      subscription.update!(
        status: stripe_subscription.status,
        ends_at: ends_at
      )
    rescue ActiveRecord::RecordNotFound
      context.fail!(error: 'Subscription not found.')
    end
  end
end
