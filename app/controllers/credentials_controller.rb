class CredentialsController < ApplicationController
  before_action :load_and_authorize_resource
  before_action :check_webauthn, only: :create

  layout 'devise', only: [:new]

  def index; end

  def new
    current_user.update!(webauthn_id: WebAuthn.generate_user_id) unless current_user.webauthn_id

    @options = generate_challenge

    session[:creation_challenge] = @options.challenge
  end

  def create
    @credential = current_user.credentials.new(
      credential_params.merge(
        webauthn_id: @webauthn_credential.id,
        public_key: @webauthn_credential.public_key,
        sign_count: @webauthn_credential.sign_count
      )
    )

    @credential.save!

    redirect_to edit_accounts_password_url, notice: 'Passkey was successfully created.'
  end

  def destroy
    @credential.destroy

    redirect_to credentials_url
  end

  def update
    @credential.update(credential_params)

    render turbo_stream: turbo_stream.replace(@credential)
  end

  private

  def generate_challenge
    WebAuthn::Credential.options_for_create(
      user: { id: current_user.webauthn_id, name: current_user.full_name },
      exclude: current_user.credentials.pluck(:webauthn_id)
    )
  end

  def check_webauthn
    @webauthn_credential = WebAuthn::Credential.from_create(
      JSON.parse(params[:public_key_credential])
    )
    @webauthn_credential.verify(session[:creation_challenge])
  rescue WebAuthn::Error
    redirect_to new_credential_path, alert: 'Something went wrong. Please try again.'
  end

  def credential_params
    params.require(:credential).permit(:name)
  end
end
