require 'spec_helper'

describe Api::V1::SessionsController, type: :controller do
  render_views

  let(:user_params) {
    { user: { email: 'spec@rails.com', password: 'specspec' } }
  }

  describe 'create' do
    before :each do
      @user = FactoryBot.create(:user, user_params[:user])
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end

    context 'with valid params' do
      it 'should return 201' do
        post :create, params: user_params, format: :json
        expect(response.status).to equal(201)
      end

      it 'should return the right json object' do
        post :create, params: user_params, format: :json
        json = JSON.parse(response.body)
        expect(json).to have_key('id')
        expect(json).to have_key('email')
      end
    end

    context 'with invalid params' do
      it 'should return 401' do
        invalid_params = { user: { email: 'spec@rails.com', password: 'spec' } }
        post :create, params: invalid_params, format: :json
        expect(response.status).to equal(401)
      end
    end
  end
end
