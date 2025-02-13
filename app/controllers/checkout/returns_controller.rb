module Checkout
  class ReturnsController < ApplicationController
    before_action :require_current_account_admin!

    def show
      skip_authorization

      result = Subscriptions::CheckPayment.call(
        session_id: params[:session_id],
        user: current_user,
        account: Current.account
      )

      if result.success?
        flash[:notice] = 'Your subscription was successful!'
      else
        flash[:alert] = 'There was an issue with your subscription. Please try again.'
      end

      redirect_to return_path
    end

    private

    def return_path
      params.fetch(:return_to, root_path)
    end
  end
end
