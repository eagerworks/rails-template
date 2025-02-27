# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    prepend_before_action :check_two_factor, only: :create

    private

    def check_two_factor
      user = User.find_by(email: params[:user][:email])

      return unless user&.valid_password?(params[:user][:password]) && user.two_factor_enabled?

      set_two_factor_session

      redirect_to new_two_factor_path
    end

    def set_two_factor_session
      session[:two_factor_user_id] = user.id
      session[:remember_me] = params[:user][:remember_me] == '1'
    end
  end
end
