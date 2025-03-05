require 'rails_helper'

RSpec.describe AccountPolicy, type: :policy do
  let(:user) { create(:user) }

  subject { described_class }

  permissions '.scope' do
    let!(:personal_accounts) { create_list(:account, 3, :with_user, user: user) }
    let!(:other_accounts) { create_list(:account, 3) }

    it 'returns only the accounts the user belongs to' do
      expect(Pundit.policy_scope(user, Account).to_a).to match_array(personal_accounts)
    end
  end

  shared_examples 'an account policy' do
    context 'when the user belongs to the account' do
      let(:account) { create(:account, :with_user, user: user) }

      it 'allows access' do
        expect(subject).to permit(user, account)
      end
    end

    context 'when the user doesn\'t belong to the account' do
      let(:account) { create(:account) }

      it 'denies access' do
        expect(subject).not_to permit(user, account)
      end
    end
  end

  permissions :show? do
    it_behaves_like 'an account policy'
  end

  permissions :create? do
    it 'allows users to create accounts' do
      expect(subject).to permit(user)
    end
  end

  permissions :update? do
    it "isn't allowed by default" do
      expect(subject).not_to permit(user)
    end
  end

  permissions :destroy? do
    it "isn't allowed by default" do
      expect(subject).not_to permit(user)
    end
  end

  permissions :switch? do
    it_behaves_like 'an account policy'
  end
end
