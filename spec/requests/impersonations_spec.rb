require 'rails_helper'

RSpec.describe 'Impersonations', type: :request do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  before do
    sign_in admin
  end

  describe 'DELETE /destroy' do
    subject { delete impersonations_path }

    it 'authorizes the impersonation' do
      expect_any_instance_of(ImpersonationPolicy).to receive(:destroy?).and_return(true)
      subject
    end

    it 'redirects back' do
      subject
      expect(response).to redirect_to(root_path)
    end
  end
end
