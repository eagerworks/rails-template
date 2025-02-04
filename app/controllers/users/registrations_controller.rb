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

    protected

    def build_resource(hash = {})
      self.resource = resource_class.new_with_session(hash, session)

      # Registering to accept an invitation should display the invitation on sign up
      if params[:invite] && (invite = AccountInvitation.find_by(token: params[:invite]))
        @account_invitation = invite
        resource.skip_confirmation!
      end
    end

    def sign_up_params
      params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
    end

    def account_update_params
      params.require(:user).permit(:full_name, :email, :avatar)
    end

    def sign_up(resource_name, resource)
      super

      # If user registered through an invitation, automatically accept it after signing in
      return unless @account_invitation

      ::AccountInvitations::Accept.call!(invitation: @account_invitation, user: current_user)

      # Clear redirect to account invitation since it's already been accepted
      stored_location_for(:user)
    end
  end
end
