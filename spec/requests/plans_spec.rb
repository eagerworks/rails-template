require 'rails_helper'

RSpec.describe 'Plans', type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET /index' do
    subject { get plans_path }

    let!(:monthly_plan) { create(:plan, :published, interval: 'monthly', amount: 100) }
    let!(:yearly_plan) { create(:plan, :published, interval: 'yearly', amount: 1000) }
    let!(:other_monthly_plan) { create(:plan, :published, interval: 'monthly', amount: 50) }

    it 'renders the index template' do
      subject
      expect(response).to render_template(:index)
    end

    context 'when no interval is specified' do
      it 'shows monthly plans ordered by amount' do
        subject
        expect(assigns(:plans)).to eq([other_monthly_plan, monthly_plan])
      end
    end

    context 'when yearly interval is specified' do
      subject { get plans_path(interval: 'yearly') }

      it 'shows yearly plans ordered by amount' do
        subject
        expect(assigns(:plans)).to eq([yearly_plan])
      end
    end
  end
end
