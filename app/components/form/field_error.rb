# frozen_string_literal: true

module Form
  class FieldError < BaseComponent
    erb_template <<-ERB
    <p class="mt-2 text-sm text-red-600"><%= @error %></p>
    ERB

    def initialize(error:)
      super()

      @error = error
    end

    def render?
      @error.present?
    end
  end
end
