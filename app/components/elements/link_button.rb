# frozen_string_literal: true

module Elements
  class LinkButton < Button
    def initialize(href:, **attributes)
      super(**attributes)

      @href = href
    end

    def classes
      class_list(super, 'text-center')
    end
  end
end
