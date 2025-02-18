module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: [:google_oauth2, :facebook]

    def google_oauth2
      @user = User.from_omniauth(request.env['omniauth.auth'])

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    end

    def facebook
      @user = User.from_omniauth(request.env['omniauth.auth'])

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end

    def failure
      redirect_to root_path
    end
  end
end
