# frozen_string_literal: true

module Billing
  class StripeCheckout < BaseComponent
    def initialize(session_url:)
      super()

      @session_url = session_url
    end

    def alpine_data
      "stripeCheckout('#{Rails.configuration.stripe[:publishable_key]}', '#{@session_url}')"
    end

    erb_template <<~ERB
      <div x-data="<%= alpine_data %>">
      </div>
    ERB
  end
end
