require 'rails_helper'

RSpec.describe PlanPolicy, type: :policy do
  let(:user) { create(:user) }

  subject { described_class }

  permissions '.scope' do
    let!(:published_plans) { create_list(:plan, 3, :published) }
    let!(:unpublished_plans) { create_list(:plan, 3, :private) }

    it 'returns only published plans' do
      expect(subject::Scope.new(user, Plan).resolve).to match_array(published_plans)
    end
  end

  permissions :show? do
    it 'grants access to any user' do
      expect(subject).to permit(user)
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
    it "isn't allowed by default" do
      expect(subject).not_to permit(user)
    end
  end
end
