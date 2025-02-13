module Subscriptions
  class PaymentMethodsController < ApplicationController
    before_action :require_current_account_admin!
    before_action :check_stripe_id

    def new
      skip_authorization

      session = Stripe::BillingPortal::Session.create({
                                                        customer: @stripe_id,
                                                        return_url: subscriptions_url
                                                      })

      redirect_to session.url, allow_other_host: true
    end

    private

    def check_stripe_id
      @stripe_id = current_user.stripe_id

      return if @stripe_id.present?

      redirect_back fallback_location: root_path, alert: "You don't have a subscription."
    end
  end
end
