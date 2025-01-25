module Accounts
  class PasswordsController < ApplicationController
    layout 'settings'

    before_action :authenticate_user!
    before_action :load_user

    def edit
    end

    def update
      if @user.update_with_password(password_params)
        bypass_sign_in @user
        flash.now[:notice] = 'Your password was changed successfully.'
        render turbo_stream: turbo_stream.replace('flash_messages',
                                                  partial: 'layouts/flash_messages')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def password_params
      params.require(:user).permit(:current_password, :password, :password_confirmation)
    end

    def load_user
      @user = authorize current_user
    end
  end
end
