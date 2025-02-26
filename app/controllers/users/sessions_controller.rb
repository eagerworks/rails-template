# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  prepend_before_action :check_two_factor!, only: :create

  private

  def check_two_factor!
    user = User.find_by(email: params[:user][:email])

    if user.valid_password?(params[:user][:password]) && user.two_factor_enabled?
      session[:two_factor_user_id] = user.id

      redirect_to new_two_factor_path
    end
  end
end
