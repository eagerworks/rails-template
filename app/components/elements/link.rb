# frozen_string_literal: true

module Elements
  class Link < BaseComponent
    def initialize(href:, turbo: true, turbo_frame: nil, **attributes)
      super(**attributes)

      @href = href

      return unless turbo

      @attributes ||= {}
      @attributes[:data] ||= {}
      @attributes[:data][:turbo] = true
      @attributes[:data][:turbo_frame] = turbo_frame if turbo_frame
    end
  end
end
