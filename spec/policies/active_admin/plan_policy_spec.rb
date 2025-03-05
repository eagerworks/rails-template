require 'rails_helper'

RSpec.describe ActiveAdmin::PlanPolicy, type: :policy do
  let(:user) { create(:user, :admin) }

  subject { described_class }

  permissions '.scope' do
    it_behaves_like 'admin scope', :plan
  end

  permissions :show? do
    it_behaves_like 'admin access'
  end

  permissions :create? do
    it_behaves_like 'admin access'
  end

  permissions :update? do
    it_behaves_like 'admin access'
  end

  permissions :destroy? do
    it_behaves_like 'admin access'
  end
end
