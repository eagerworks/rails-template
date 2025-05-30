module Subscriptions
  class CheckPayment
    include Interactor

    def call
      context.fail!(error: 'The payment failed or was canceled.') if session.status != 'complete'

      update_user
      context.subscription = create_subscription
      notify_user
    end

    private

    def notify_user
      NewSubscriptionNotifier.with(subscription: context.subscription)
                             .deliver(context.account.users)
    end

    def create_subscription
      Subscription.create!(subscription_attributes)
    end

    def subscription_attributes
      {
        plan: plan,
        account: context.account,
        quantity: subscription.quantity,
        ends_at: Time.at(subscription.current_period_end),
        stripe_id: subscription.id,
        trial_ends_at: trial_ends_at
      }
    end

    def trial_ends_at
      subscription.trial_end && Time.at(subscription.trial_end)
    end

    def subscription
      @subscription ||= Stripe::Subscription.retrieve(session.subscription)
    end

    def plan
      @plan ||= Plan.find_by(stripe_id: subscription.plan.id)
    end

    def session
      @session ||= Stripe::Checkout::Session.retrieve(context.session_id)
    end

    def customer
      @customer ||= Stripe::Customer.retrieve(session.customer)
    end

    def update_user
      context.user.update!(stripe_id: customer.id)
    end
  end
end
