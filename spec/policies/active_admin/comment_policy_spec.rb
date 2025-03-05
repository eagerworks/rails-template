require 'rails_helper'

RSpec.describe ActiveAdmin::CommentPolicy, type: :policy do
  let(:user) { create(:user, :admin) }

  subject { described_class }

  permissions '.scope' do
    let!(:own_comments) { create_list(:active_admin_comment, 3, author: user) }
    let!(:other_comments) { create_list(:active_admin_comment, 3) }

    it 'returns only own comments' do
      expect(subject::Scope.new(user, ActiveAdmin::Comment).resolve).to match_array(own_comments)
    end
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
    context 'when user is the author' do
      let(:comment) { create(:active_admin_comment, author: user) }

      it 'grants access' do
        expect(subject).to permit(user, comment)
      end
    end

    context 'when user is not the author' do
      let(:comment) { create(:active_admin_comment) }

      it 'denies access' do
        expect(subject).not_to permit(user, comment)
      end
    end
  end
end
