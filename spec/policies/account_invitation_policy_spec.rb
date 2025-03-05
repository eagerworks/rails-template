require 'rails_helper'

RSpec.describe AccountInvitationPolicy, type: :policy do
  let(:user) { create(:user) }

  subject { described_class }

  permissions :show? do
    it "isn't allowed by default" do
      expect(subject).not_to permit(user)
    end
  end

  shared_examples 'an admin policy' do
    context 'when the user is an admin' do
      let(:account_user) { create(:account_user, role: 'admin', user: user) }
      let(:account_invitation) { create(:account_invitation, account: account_user.account) }

      it 'allows access' do
        expect(subject).to permit(user, account_invitation)
      end
    end

    context 'when the user is not an admin' do
      let(:account_user) { create(:account_user, role: 'member', user: user) }
      let(:account_invitation) { create(:account_invitation, account: account_user.account) }

      it 'denies access' do
        expect(subject).not_to permit(user, account_invitation)
      end
    end

    context 'when the user doens\'t belong to the account' do
      let(:account_invitation) { create(:account_invitation) }

      it 'denies access' do
        expect(subject).not_to permit(user, account_invitation)
      end
    end
  end

  permissions :create? do
    context 'when the account is personal' do
      let(:account) { create(:account, personal: true) }
      let(:account_user) { create(:account_user, account: account, role: 'admin', user: user) }
      let(:account_invitation) { create(:account_invitation, account: account) }

      it "doesn't allow the user to create an account invitation" do
        expect(subject).not_to permit(user, account_invitation)
      end
    end

    it_behaves_like 'an admin policy'
  end

  permissions :update? do
    it_behaves_like 'an admin policy'
  end

  permissions :destroy? do
    it_behaves_like 'an admin policy'
  end

  permissions :resend? do
    it_behaves_like 'an admin policy'
  end
end
