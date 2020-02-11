require 'spec_helper'

describe Api::V1::RegistrationsController, type: :controller do
  render_views

  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'create' do
    context 'with valid params' do
      let(:user_params) {
        { user: FactoryBot.attributes_for(:user) }
      }

      it 'should return 201' do
        post :create, params: user_params, format: :json
        expect(response.status).to equal(201)
      end

      it 'should create user' do
        expect{
          post :create, params: user_params, format: :json
        }.to change(User, :count).by(1)
      end
    end

    context 'with invalid params' do
      let(:user_params) {
        { user: FactoryBot.attributes_for(:user, password: '') }
      }

      it 'should return 422' do
        post :create, params: user_params, format: :json
        expect(response.status).to equal(422)
      end

      it 'should not create user' do
        expect{
          post :create, params: user_params, format: :json
        }.to_not change(User, :count)
      end

      it 'should return the right json object' do
        post :create, params: user_params, format: :json
        json = JSON.parse(response.body)
        expect(json).to have_key('errors')
      end
    end
  end
end
