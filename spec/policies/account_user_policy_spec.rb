require 'rails_helper'

RSpec.describe AccountUserPolicy, type: :policy do
  let(:account) { create(:account) }
  let(:account_user) { create(:account_user, account: account) }
  let(:user) { create(:account_user, account: account).user }
  subject { described_class }

  shared_examples 'an account user policy' do
    context 'when the user is an admin' do
      let(:user) { create(:account_user, :admin, account: account).user }

      it 'allows access' do
        expect(subject).to permit(user, account_user)
      end
    end

    context 'when the user is a member' do
      let(:user) { create(:account_user, :member, account: account).user }

      it 'denies access' do
        expect(subject).not_to permit(user, account_user)
      end
    end

    context 'when the user doesn\'t belong to the account' do
      let(:user) { create(:account_user, :admin).user }

      it 'denies access' do
        expect(subject).not_to permit(user, account_user)
      end
    end
  end

  permissions :show? do
    it "isn't allowed by default" do
      expect(subject).not_to permit(user)
    end
  end

  permissions :create? do
    it "isn't allowed by default" do
      expect(subject).not_to permit(user)
    end
  end

  permissions :update? do
    it_behaves_like 'an account user policy'

    context 'when the user is the account owner' do
      let(:account_user) { create(:account_user, :owner) }
      let(:user) { create(:account_user, :admin, account: account).user }

      it 'denies access' do
        expect(subject).not_to permit(user, account_user)
      end
    end
  end

  permissions :destroy? do
    it_behaves_like 'an account user policy'

    context 'when the user is the account owner' do
      let(:account_user) { create(:account_user, :owner) }
      let(:user) { create(:account_user, :admin, account: account).user }

      it 'denies access' do
        expect(subject).not_to permit(user, account_user)
      end
    end

    it 'allows the account owner to remove themselves' do
      account_user = create(:account_user, :member)
      expect(subject).to permit(account_user.user, account_user)
    end
  end

  permissions :edit? do
    it_behaves_like 'an account user policy'
  end
end
