# frozen_string_literal: true

module Notifications
  class Toast < ViewComponent::Base
    attr_reader :notification

    use_helpers :heroicon

    def initialize(notification:)
      @notification = notification

      super()
    end
  end
end
