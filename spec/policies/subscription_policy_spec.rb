require 'rails_helper'

RSpec.describe SubscriptionPolicy, type: :policy do
  let(:user) { account_user.user }
  let(:account_user) { create(:account_user) }
  let(:subscription) { create(:subscription) }

  subject { described_class }

  before(:each) do
    Current.account = account_user.account
    Current.user = user
  end

  shared_examples 'an account admin' do
    context 'when the user is an account admin' do
      before do
        account_user.update(role: :admin)
      end

      it 'grants access' do
        expect(subject).to permit(user, subscription)
      end
    end

    context 'when the user is not an account admin' do
      before do
        account_user.update(role: :member)
      end

      it 'denies access' do
        expect(subject).not_to permit(user, subscription)
      end
    end
  end

  shared_examples 'an active subscription' do
    context 'when the subscription is active' do
      let(:subscription) { create(:subscription, :active, account: account_user.account) }

      it_behaves_like 'an account admin'
    end

    context 'when the subscription is not active' do
      let(:subscription) { create(:subscription, :ended, account: account_user.account) }

      it 'denies access' do
        expect(subject).not_to permit(user, subscription)
      end
    end

    context 'when the subscription is not associated with the account' do
      let(:subscription) { create(:subscription) }

      it 'denies access' do
        expect(subject).not_to permit(user, subscription)
      end
    end
  end

  permissions :index? do
    context 'when the account is not subscribed' do
      let(:account_user) { create(:account_user, :admin) }

      it 'denies access' do
        expect(subject).not_to permit(user)
      end
    end

    context 'when the account is already subscribed' do
      before do
        create(:subscription, account: account_user.account)
      end

      it_behaves_like 'an account admin'
    end
  end

  permissions :show? do
    context 'when the subscription is active' do
      let(:subscription) { create(:subscription, :active, account: account_user.account) }

      it_behaves_like 'an account admin'
    end

    context 'when the subscription is on grace period' do
      let(:subscription) { create(:subscription, :on_grace_period, account: account_user.account) }

      it_behaves_like 'an account admin'
    end

    context 'when the subscription is not active or on grace period' do
      let(:subscription) { create(:subscription, :ended, account: account_user.account) }

      it 'denies access' do
        expect(subject).not_to permit(user, subscription)
      end
    end

    context 'when the subscription is not associated with the account' do
      let(:subscription) { create(:subscription) }

      it 'denies access' do
        expect(subject).not_to permit(user, subscription)
      end
    end
  end

  permissions :create? do
    it_behaves_like 'an account admin'
  end

  permissions :update? do
    it_behaves_like 'an active subscription'
  end

  permissions :destroy? do
    it "isn't allowed by default" do
      expect(subject).not_to permit(user)
    end
  end

  permissions :cancel? do
    it_behaves_like 'an active subscription'
  end

  permissions :renew? do
    context 'when the subscription is on grace period' do
      let(:subscription) { create(:subscription, :on_grace_period, account: account_user.account) }

      it_behaves_like 'an account admin'
    end

    context 'when the subscription is active' do
      let(:subscription) { create(:subscription, :active, account: account_user.account) }

      it 'denies access' do
        expect(subject).not_to permit(user, subscription)
      end
    end

    context 'when the subscription is not associated with the account' do
      let(:subscription) { create(:subscription) }

      it 'denies access' do
        expect(subject).not_to permit(user, subscription)
      end
    end

    context 'when the subscription is not on grace period' do
      let(:subscription) { create(:subscription, :ended, account: account_user.account) }

      it 'denies access' do
        expect(subject).not_to permit(user, subscription)
      end
    end
  end
end
