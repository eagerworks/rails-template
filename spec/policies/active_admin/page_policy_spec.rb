require 'rails_helper'

RSpec.describe ActiveAdmin::PagePolicy, type: :policy do
  let(:user) { create(:user, :admin) }

  subject { described_class }

  permissions :show? do
    it 'grants access to admin pages' do
      allowed_pages = ['Dashboard']

      allowed_pages.each do |page_name|
        expect(subject).to permit(user, double(name: page_name))
      end
    end

    it 'denies access to other pages' do
      expect(subject).not_to permit(user, double(name: 'Other'))
    end
  end
end
