# frozen_string_literal: true

module Elements
  class List < BaseComponent
    renders_many :sections, 'ListSection'
    renders_many :items, 'ListItem'

    def initialize(divider: false, **attributes)
      super(**attributes)

      @divider = divider
    end

    class ListItem < BaseComponent
      def initialize(href:, **attributes)
        super(**attributes)

        @href = href
      end

      erb_template <<~ERB
        <li>
          <%= link_to(
            @href,
            class: 'block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 hover:text-gray-900 hover:outline-none',
            role: 'menuitem',
            tabindex: -1,
            **attributes
          ) do %>
            <%= content %>
          <% end %>
        </li>
      ERB
    end

    class ListSection < BaseComponent
      renders_many :items, ListItem

      erb_template <<~ERB
        <ul class="py-1" role="none">
          <% items.each do |item| %>
            <%= item %>
          <% end %>
        </ul>
      ERB
    end
  end
end
