# frozen_string_literal: true

module Elements
  class Dropdown < Base
    renders_many :items, 'DropdownItem'
    renders_one :button

    def initialize(align: :left)
      super()

      @align = align
    end

    def focus_classes
      class_list(
        'focus-visible:outline focus-visible:outline-2',
        'focus-visible:outline-offset-2',
        'focus-visible:outline-indigo-600'
      )
    end

    def align_classes
      case @align
      when :left
        'origin-top-left left-0'
      when :right
        'origin-top-right right-0'
      end
    end

    class DropdownItem < Base
      def initialize(href:, **attributes)
        super(**attributes)

        @href = href
      end

      erb_template <<~ERB
        <%= link_to(
          @href,
          class: 'block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 hover:text-gray-900 hover:outline-none',
          role: 'menuitem',
          tabindex: -1,
          **attributes
        ) do %>
          <%= content %>
        <% end %>
      ERB
    end
  end
end
