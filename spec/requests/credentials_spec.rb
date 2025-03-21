require 'rails_helper'

RSpec.describe 'Credentials', type: :request do
  let(:user) { create(:user) }
  let!(:credential) { create(:credential, user: user) }

  before { sign_in user }

  describe 'GET /index' do
    subject { get credentials_path }

    it_behaves_like 'authenticated request'

    it 'renders the index template' do
      subject
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /new' do
    subject { get new_credential_path }

    it_behaves_like 'authenticated request'

    it 'renders the new template' do
      subject
      expect(response).to render_template(:new)
    end

    it 'generates a webauthn_id for the user if not present' do
      user.update!(webauthn_id: nil)
      expect { subject }.to change { user.reload.webauthn_id }.from(nil)
    end

    it 'generates challenge options' do
      subject
      expect(assigns(:options)).to be_present
      expect(controller.session[:creation_challenge]).to be_present
    end
  end

  describe 'POST /create' do
    subject { post credentials_path, params: params }

    it_behaves_like 'authenticated request'

    let(:webauthn_credential) do
      double(
        id: 'credential_id',
        public_key: 'public_key',
        sign_count: 0,
        verify: true
      )
    end

    let(:params) do
      {
        public_key_credential: {
          id: 'credential_id',
          type: 'public-key',
          rawId: 'raw_id',
          response: {
            clientDataJSON: 'client_data_json',
            attestationObject: 'attestation_object'
          }
        }.to_json,
        credential: { name: 'New Credential' }
      }
    end

    before do
      allow(WebAuthn::Credential).to receive(:from_create).and_return(webauthn_credential)
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(
        { creation_challenge: 'challenge' }
      )
    end

    context 'with valid parameters' do
      it 'creates a new credential' do
        expect { subject }.to change(Credential, :count).by(1)
      end

      it 'sets the credential attributes' do
        subject
        credential = Credential.last
        expect(credential.webauthn_id).to eq('credential_id')
        expect(credential.public_key).to eq('public_key')
        expect(credential.sign_count).to eq(0)
        expect(credential.name).to eq('New Credential')
      end

      it 'redirects to edit password page' do
        subject
        expect(response).to redirect_to(edit_accounts_password_url)
      end

      it 'sets a success notice' do
        subject
        expect(flash[:notice]).to eq('Passkey was successfully created.')
      end
    end

    context 'when webauthn verification fails' do
      before do
        allow(webauthn_credential).to receive(:verify).and_raise(WebAuthn::Error)
      end

      it 'redirects to new credential path' do
        subject
        expect(response).to redirect_to(new_credential_path)
      end

      it 'sets an error message' do
        subject
        expect(flash[:alert]).to eq('Something went wrong. Please try again.')
      end
    end
  end

  describe 'DELETE /destroy' do
    subject { delete credential_path(credential) }

    it_behaves_like 'authenticated request'

    it 'destroys the credential' do
      expect { subject }.to change(Credential, :count).by(-1)
    end

    it 'redirects to credentials index' do
      subject
      expect(response).to redirect_to(credentials_url)
    end
  end

  describe 'PATCH /update' do
    subject { patch credential_path(credential), params: { credential: { name: 'Updated Name' } } }

    it_behaves_like 'authenticated request'

    it 'updates the credential' do
      expect { subject }.to change { credential.reload.name }.to('Updated Name')
    end

    it 'renders a turbo stream' do
      subject
      expect(response.content_type).to include('text/vnd.turbo-stream.html')
    end
  end
end
