require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:user) { create(:user) }

  subject { described_class }

  permissions :show? do
    it 'isn\'t allowed by default' do
      expect(subject).not_to permit(user)
    end
  end

  permissions :create? do
    it 'isn\'t allowed by default' do
      expect(subject).not_to permit(user)
    end
  end

  permissions :update? do
    it 'is allowed for the user' do
      expect(subject).to permit(user, user)
    end

    it 'isn\'t allowed for other users' do
      other_user = create(:user)
      expect(subject).not_to permit(other_user, user)
    end
  end

  permissions :destroy? do
    it 'isn\'t allowed by default' do
      expect(subject).not_to permit(user)
    end
  end
end
