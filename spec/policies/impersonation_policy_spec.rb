require 'rails_helper'

RSpec.describe ImpersonationPolicy, type: :policy do
  let(:user) { create(:user) }

  subject { described_class }

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
    it "isn't allowed by default" do
      expect(subject).not_to permit(user)
    end
  end

  permissions :destroy? do
    context 'when the user is an admin' do
      let(:user) { create(:user, :admin) }

      it 'allows access' do
        expect(subject).to permit(user)
      end
    end

    context 'when the user is not an admin' do
      it 'denies access' do
        expect(subject).not_to permit(user)
      end
    end
  end
end
