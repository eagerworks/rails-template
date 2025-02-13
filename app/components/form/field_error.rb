# frozen_string_literal: true

module Form
  class FieldError < BaseComponent
    erb_template <<-ERB
    <div class="text-red-500 text-sm mt-2"><%= @error %></div>
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
