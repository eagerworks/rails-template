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

    user.credentials.create!(
      webauthn_id: webauthn_credential.id,
      public_key: webauthn_credential.public_key,
      sign_count: webauthn_credential.sign_count
    )
  end
end
