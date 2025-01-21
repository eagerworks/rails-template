module Users
  class RegistrationsController < Devise::RegistrationsController
    layout 'settings', only: [:edit]

    def update
      @user = current_user

      if @user.update(account_update_params)
        flash.now[:notice] = 'Your profile was updated successfully.'
        render turbo_stream: turbo_stream.replace('flash_messages',
                                                  partial: 'layouts/flash_messages')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def sign_up_params
      params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
    end

    def account_update_params
      params.require(:user).permit(:full_name, :email, :avatar)
    end
  end
end
