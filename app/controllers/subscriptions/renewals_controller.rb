module Subscriptions
  class RenewalsController < ApplicationController
    before_action :load_subscription
    before_action :require_current_account_admin!

    def show; end

    def create
      result = Subscriptions::Renew.call(subscription: @subscription)

      if result.success?
        redirect_to root_path, notice: 'Subscription renewed.'
      else
        redirect_to root_path, alert: result.error
      end
    end

    private

    def load_subscription
      @subscription = Current.account.subscription

      unless @subscription.present?
        redirect_to root_path, alert: 'You do not have a subscription.'

        return
      end

      authorize @subscription, :renew?
    end
  end
end
