require 'rails_helper'

RSpec.describe ActiveAdmin::AccountPolicy, type: :policy do
  subject { described_class }

  permissions '.scope' do
    it_behaves_like 'admin scope', :account
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
