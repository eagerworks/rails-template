module Subscriptions
  class CancelsController < ApplicationController
    before_action :load_subscription
    before_action :require_current_account_admin!

    def show; end

    def destroy
      result = Subscriptions::Cancel.call(subscription: @subscription)

      if result.success?
        redirect_to root_path, notice: 'Your subscription has been canceled.'
      else
        redirect_to root_path, alert: 'There was a problem canceling your subscription.'
      end
    end

    private

    def load_subscription
      @subscription = Current.account.subscription

      unless @subscription.present?
        redirect_to root_path, alert: 'You do not have a subscription.'

        return
      end

      authorize @subscription, :cancel?
    end
  end
end
