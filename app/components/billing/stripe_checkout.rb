# frozen_string_literal: true

module Billing
  class StripeCheckout < BaseComponent
    def initialize(session_url:)
      super()

      @session_url = session_url
    end
  end
end
