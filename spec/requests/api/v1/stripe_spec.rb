require 'rails_helper'

RSpec.describe 'Api::V1::Stripes', type: :request do
  describe 'POST /api/v1/webhooks/stripe' do
    let(:params) do
      {
        id: 'evt_123',
        object: 'event',
        type: 'customer.subscription.deleted',
        data: {
          object: {
            id: 'sub_123',
            status: 'canceled',
            current_period_end: Time.now.to_i
          }
        }
      }
    end
    let(:headers) do
      time = Time.now
      secret = Rails.application.credentials.dig(:stripe, :webhook_secret)
      signature = Stripe::Webhook::Signature.compute_signature(time, params.to_json, secret)
      header = Stripe::Webhook::Signature.generate_header(
        time,
        signature,
        scheme: Stripe::Webhook::Signature::EXPECTED_SCHEME
      )
      { 'HTTP_STRIPE_SIGNATURE' => header }
    end

    it 'returns a 204 status' do
      post '/api/v1/webhooks/stripe', params: params, headers: headers, as: :json

      expect(response).to have_http_status(:no_content)
    end

    it 'calls the Stripe::HandleWebhook service' do
      expect(Stripe::HandleWebhook).to receive(:call).with(event: instance_of(Stripe::Event))

      post '/api/v1/webhooks/stripe', params: params, headers: headers, as: :json
    end

    context 'when params are invalid' do
      let(:invalid_params) { {} }

      it 'returns a 400 status' do
        post '/api/v1/webhooks/stripe', params: invalid_params, as: :json

        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
