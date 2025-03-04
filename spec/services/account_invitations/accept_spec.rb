require 'rails_helper'

RSpec.describe AccountInvitations::Accept, type: :service do
  let!(:invitation) { create(:account_invitation) }
  let!(:user) { create(:user) }
  subject { described_class.call(invitation: invitation, user: user) }

  it 'creates an account user' do
    expect { subject }.to change { AccountUser.count }.by(1)

    account_user = AccountUser.last
    expect(account_user.account).to eq(invitation.account)
    expect(account_user.user).to eq(user)
    expect(account_user.role).to eq(invitation.role)
  end

  it 'destroys the invitation' do
    expect { subject }.to change { AccountInvitation.count }.by(-1)
  end

  it 'returns the account user' do
    expect(subject).to be_a_success
    expect(subject.payload).to be_a(AccountUser)
  end

  it 'returns a success' do
    expect(subject.success?).to be_truthy
  end
end
