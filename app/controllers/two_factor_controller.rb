class TwoFactorController < ApplicationController
  include Devise::Controllers::Rememberable

  before_action :user_not_authenticated
  before_action :skip_authorization
  before_action :load_user
  before_action :check_webauthn, only: :create

  def new
    @options = WebAuthn::Credential.options_for_get(allow: @user.credentials.pluck(:webauthn_id))
    session[:authentication_challenge] = @options.challenge
  end

  def create
    @stored_credential.update!(
      sign_count: @webauthn_credential.sign_count,
      last_used_at: Time.zone.now
    )

    sign_in @user

    remember_me(@user) if session[:remember_me]

    redirect_to root_path, notice: 'You have successfully signed in.'
  rescue WebAuthn::SignCountVerificationError
    redirect_to new_two_factor_path, alert: 'Sign count verification failed.'
  end

  private

  def check_webauthn
    @webauthn_credential = WebAuthn::Credential.from_get(JSON.parse(params[:public_key_credential]))
    @stored_credential = @user.credentials.find_by(webauthn_id: @webauthn_credential.id)

    @webauthn_credential.verify(
      session[:authentication_challenge],
      public_key: @stored_credential.public_key,
      sign_count: @stored_credential.sign_count
    )
  rescue WebAuthn::Error
    redirect_to new_two_factor_path, alert: 'Something went wrong. Please try again.'
  end

  def load_user
    @user = User.find(session[:two_factor_user_id])

    return if @user.present?

    redirect_to new_user_session_path, alert: 'Invalid session'
  end

  def user_not_authenticated
    return unless current_user

    redirect_to root_path, alert: 'You are already signed in.'
  end
end
