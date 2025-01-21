# frozen_string_literal: true

module Elements
  class LinkButton < Button
    def initialize(href:, **attributes)
      super(**attributes)

      @href = href
    end
  end
end
