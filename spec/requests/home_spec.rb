require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET /index' do
    subject { get root_path }

    it 'renders the index template' do
      subject
      expect(response).to render_template(:index)
    end

    it 'returns a successful response' do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
