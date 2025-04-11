require 'rails_helper'

RSpec.describe AccountInvitations::Update, type: :service do
  let!(:invitation) { create(:account_invitation) }

  context 'when the params are valid' do
    let(:params) { { email: 'new_email@mail.com', name: 'New Name', role: 'admin' } }
    subject { described_class.call(invitation: invitation, params: params) }

    it 'updates the invitation' do
      expect { subject }.to change { invitation.reload.email }.to(params[:email])
      expect(invitation.name).to eq(params[:name])
      expect(invitation.role).to eq(params[:role])
    end

    it 'returns the updated invitation' do
      expect(subject).to be_a_success
      expect(subject.invitation).to eq(invitation)
    end

    it 'sends an email if the email has changed' do
      expect { subject }.to have_enqueued_mail(AccountMailer, :invitation_email)
    end

    it 'does not send an email if the email has not changed' do
      params[:email] = invitation.email
      expect { subject }.not_to have_enqueued_mail(AccountMailer, :invitation_email)
    end

    it 'returns a success' do
      expect(subject.success?).to be_truthy
    end
  end

  context 'when the params are invalid' do
    let(:params) { { email: nil, name: nil, role: nil } }
    subject { described_class.call(invitation: invitation, params: params) }

    it 'does not update the invitation' do
      expect { subject }.not_to change { invitation.reload.updated_at }
      expect(invitation.errors.full_messages).to include("Email can't be blank")
      expect(invitation.errors.full_messages).to include("Name can't be blank")
    end

    it 'returns a failure' do
      expect(subject.success?).to be_falsey
    end
  end
end
