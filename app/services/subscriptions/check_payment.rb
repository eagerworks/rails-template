module Subscriptions
  class CheckPayment < ApplicationService
    def call(session_id:, user:, account:)
      @session_id = session_id
      @user = user
      @account = account

      return failure('The payment failed or was canceled.') if session.status != 'complete'

      update_user
      success(create_subscription)
    end

    private

    def create_subscription
      attributes = {
        plan: plan,
        account: @account,
        quantity: subscription.quantity,
        ends_at: Time.at(subscription.current_period_end),
        stripe_id: subscription.id,
        trial_ends_at: subscription.trial_end && Time.at(subscription.trial_end)
      }

      Subscription.create!(attributes)
    end

    def subscription
      @subscription ||= Stripe::Subscription.retrieve(session.subscription)
    end

    def plan
      @plan ||= Plan.find_by(stripe_id: subscription.plan.id)
    end

    def session
      @session ||= Stripe::Checkout::Session.retrieve(@session_id)
    end

    def customer
      @customer ||= Stripe::Customer.retrieve(session.customer)
    end

    def update_user
      @user.update!(stripe_id: customer.id)
    end
  end
end
