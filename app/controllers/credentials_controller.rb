class CredentialsController < ApplicationController
  before_action :load_and_authorize_resource

  layout 'devise', only: [:new]

  def index
  end

  def new
    if !current_user.webauthn_id
      current_user.update!(webauthn_id: WebAuthn.generate_user_id)
    end

    @options = WebAuthn::Credential.options_for_create(
      user: { id: current_user.webauthn_id, name: current_user.full_name },
      exclude: current_user.credentials.pluck(:webauthn_id)
    )

    session[:creation_challenge] = @options.challenge
  end

  def create
    webauthn_credential = WebAuthn::Credential.from_create(
      JSON.parse(params[:public_key_credential])
    )
    webauthn_credential.verify(session[:creation_challenge])

    @credential.webauthn_id = webauthn_credential.id
    @credential.public_key = webauthn_credential.public_key
    @credential.sign_count = webauthn_credential.sign_count

    @credential.save!

    redirect_to edit_accounts_password_url, notice: 'Passkey was successfully created.'
  end

  def destroy
    @credential.destroy

    render turbo_stream: turbo_stream.remove(@credential)
  end

  def update
    @credential.update(credential_params)

    render turbo_stream: turbo_stream.replace(@credential)
  end

  private

  def credential_params
    params.require(:credential).permit(:name).merge(user: current_user)
  end
end
