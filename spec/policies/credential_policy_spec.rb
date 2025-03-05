require 'rails_helper'

RSpec.describe CredentialPolicy, type: :policy do
  let(:user) { create(:user) }

  subject { described_class }

  permissions '.scope' do
    let!(:user_credentials) { create_list(:credential, 3, user: user) }
    let!(:other_credentials) { create_list(:credential, 3) }

    it 'returns only the credentials the user owns' do
      expect(Pundit.policy_scope(user, Credential).to_a).to match_array(user_credentials)
    end
  end

  permissions :show? do
    it "isn't allowed by default" do
      expect(subject).not_to permit(user)
    end
  end

  permissions :create? do
    it 'allows users to create credentials' do
      expect(subject).to permit(user)
    end
  end

  shared_examples 'a credential policy' do
    context 'when the user owns the credential' do
      let(:credential) { create(:credential, user: user) }

      it 'allows access' do
        expect(subject).to permit(user, credential)
      end
    end

    context 'when the user doesn\'t own the credential' do
      let(:credential) { create(:credential) }

      it 'denies access' do
        expect(subject).not_to permit(user, credential)
      end
    end
  end

  permissions :update? do
    it_behaves_like 'a credential policy'
  end

  permissions :destroy? do
    it_behaves_like 'a credential policy'
  end
end
