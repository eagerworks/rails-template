module Account
  class PasswordsController < ApplicationController
    layout 'settings'

    def edit
      @user = current_user
    end

    def update
      @user = current_user

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
  end
end
