module Api
  module V1
    class StripeController < ActionController::API
      def receive
        event = Stripe::Webhook.construct_event(
          request.body.read,
          request.headers['HTTP_STRIPE_SIGNATURE'],
          Rails.application.credentials.dig(:stripe, :webhook_secret)
        )

        Stripe::HandleWebhook.call(event: event)
      rescue Stripe::SignatureVerificationError
        render json: { error: 'Invalid signature' }, status: :bad_request
      end
    end
  end
end
