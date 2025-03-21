require 'rails_helper'

RSpec.describe 'Accounts::AccountInvitations', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account) }
  let!(:account_user) { create(:account_user, account: account, user: user, role: :admin) }
  let!(:invitation) { create(:account_invitation, account: account) }
  let(:invitation_params) { { email: 'new@example.com', name: 'New User', role: 'member' } }

  before { sign_in user }

  describe 'GET /new' do
    subject { get new_account_account_invitation_path(account) }

    it_behaves_like 'requires authorization'

    it 'renders the new template' do
      subject
      expect(response).to render_template(:new)
    end

    it 'assigns the account' do
      subject
      expect(assigns(:account)).to eq(account)
    end

    it 'builds a new invitation' do
      subject
      expect(assigns(:account_invitation)).to be_a_new(AccountInvitation)
    end
  end

  describe 'POST /create' do
    subject do
      post account_account_invitations_path(account),
           params: { account_invitation: invitation_params }
    end

    it_behaves_like 'requires authorization'

    context 'with valid parameters' do
      let(:invitation_params) { { email: 'new@example.com', name: 'New User', role: 'member' } }

      it 'creates a new invitation' do
        expect { subject }.to change(AccountInvitation, :count).by(1)
      end

      it 'sets the invited_by to current user' do
        subject
        expect(AccountInvitation.last.invited_by).to eq(user)
      end

      it 'enqueues an invitation email' do
        expect { subject }.to have_enqueued_mail(AccountMailer, :invitation_email)
      end

      it 'redirects to the account page' do
        subject
        expect(response).to redirect_to(account_path(account))
      end

      it 'sets a success notice' do
        subject
        expect(flash[:notice]).to eq('Invitation sent successfully')
      end
    end

    context 'with invalid parameters' do
      let(:invitation_params) { { email: '', name: '', role: '' } }

      it 'does not create a new invitation' do
        expect { subject }.not_to change(AccountInvitation, :count)
      end

      it 'renders the new template' do
        subject
        expect(response).to render_template(:new)
      end

      it 'returns unprocessable entity status' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /edit' do
    subject { get edit_account_account_invitation_path(account, invitation) }

    it_behaves_like 'requires authorization'

    it 'renders the edit template' do
      subject
      expect(response).to render_template(:edit)
    end

    it 'assigns the account' do
      subject
      expect(assigns(:account)).to eq(account)
    end

    it 'assigns the invitation' do
      subject
      expect(assigns(:account_invitation)).to eq(invitation)
    end
  end

  describe 'PATCH /update' do
    subject do
      patch account_account_invitation_path(account, invitation),
            params: { account_invitation: invitation_params }
    end

    it_behaves_like 'requires authorization'

    context 'with valid parameters' do
      let(:invitation_params) do
        { email: 'updated@example.com', name: 'Updated Name', role: 'admin' }
      end

      it 'calls the update service' do
        expect(AccountInvitations::Update).to(
          receive(:call).with(invitation: invitation,
                              params: invitation_params.merge(invited_by: user))
        ).and_return(double(success?: true))

        subject
      end

      it 'redirects to the account page' do
        allow(AccountInvitations::Update).to receive(:call).and_return(double(success?: true))
        subject
        expect(response).to redirect_to(account_path(account))
      end

      it 'sets a success notice' do
        allow(AccountInvitations::Update).to receive(:call).and_return(double(success?: true))
        subject
        expect(flash[:notice]).to eq('Invitation updated successfully')
      end
    end

    context 'with invalid parameters' do
      let(:invitation_params) { { email: '', name: '', role: '' } }

      it 'renders the edit template' do
        allow(AccountInvitations::Update).to receive(:call).and_return(double(success?: false))
        subject
        expect(response).to render_template(:edit)
      end

      it 'returns unprocessable entity status' do
        allow(AccountInvitations::Update).to receive(:call).and_return(double(success?: false))
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /resend' do
    subject { post resend_account_account_invitation_path(account, invitation) }

    it_behaves_like 'requires authorization'

    it 'enqueues an invitation email' do
      expect { subject }.to have_enqueued_mail(AccountMailer, :invitation_email)
    end

    it 'redirects to the account page' do
      subject
      expect(response).to redirect_to(account_path(account))
    end

    it 'sets a success notice' do
      subject
      expect(flash[:notice]).to eq('Invitation resent successfully')
    end
  end

  describe 'DELETE /destroy' do
    subject { delete account_account_invitation_path(account, invitation) }

    it_behaves_like 'requires authorization'

    it 'destroys the invitation' do
      expect { subject }.to change(AccountInvitation, :count).by(-1)
    end

    it 'redirects to the account page' do
      subject
      expect(response).to redirect_to(account_path(account))
    end

    it 'sets a success notice' do
      subject
      expect(flash[:notice]).to eq('Invitation removed successfully')
    end
  end
end
