require 'rails_helper'

RSpec.describe 'AccountInvitations', type: :request do
  let(:user) { create(:user) }
  let!(:invitation) { create(:account_invitation) }

  before(:each) do
    sign_in user
  end

  shared_examples 'invitation request' do
    context 'when the invitation does not exist' do
      let(:invalid_code) { 'invalid_code' }

      it 'redirects to the root page' do
        get account_invitation_path(invalid_code)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Invalid invitation token')
      end
    end

    context 'when user is signed out' do
      before(:each) do
        sign_out :user
      end

      it 'redirects to the sign up page' do
        subject
        expect(response).to redirect_to(new_user_registration_path(invite: invitation.token))
        expect(flash[:alert]).to eq('Please login or create an account to accept this invitation')
      end
    end

    context 'when the user belongs to the account' do
      before(:each) do
        user = create(:account_user, account: invitation.account).user
        sign_in user
      end

      it 'redirects to the accounts page' do
        subject
        expect(response).to redirect_to(accounts_path)
        expect(flash[:alert]).to eq('You are already a member of this account')
      end
    end
  end

  describe 'GET /show' do
    subject { get account_invitation_path(invitation) }

    it_behaves_like 'invitation request'

    it 'has a 200 status code' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /update' do
    subject { put account_invitation_path(invitation) }

    it_behaves_like 'invitation request'

    it 'calls the account invitation accept service' do
      expect(AccountInvitations::Accept).to(
        receive(:call).with(invitation: invitation, user: user).and_call_original
      )

      subject
    end

    context 'when the service is successful' do
      before(:each) do
        allow(AccountInvitations::Accept).to receive(:call).and_return(
          double(success?: true)
        )
      end

      it 'redirects to the accounts page' do
        subject
        expect(response).to redirect_to(accounts_path)
      end
    end

    context 'when the service is not successful' do
      before(:each) do
        allow(AccountInvitations::Accept).to receive(:call).and_return(
          double(success?: false, error: 'Error message')
        )
      end

      it 'redirects to the invitation page with an alert' do
        subject
        expect(response).to redirect_to(account_invitation_path(invitation))
        expect(flash[:alert]).to eq('Error message')
      end
    end
  end

  describe 'DELETE /destroy' do
    subject { delete account_invitation_path(invitation) }

    it_behaves_like 'invitation request'

    it 'destroys the invitation' do
      expect { subject }.to change(AccountInvitation, :count).by(-1)
    end

    it 'redirects to the root page' do
      subject
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Invitation declined')
    end
  end
end
