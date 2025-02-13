# frozen_string_literal: true

module Elements
  class TabToggle < BaseComponent
    renders_many :tabs, 'Tab'

    class Tab < BaseComponent
      attr_reader :active, :href

      def initialize(href:, active: false)
        super()

        @href = href
        @active = active
      end

      def classes
        class_list(
          'cursor-pointer rounded-full px-2.5 py-1',
          'bg-indigo-600 text-white': active,
          'text-gray-500': !active
        )
      end

      erb_template <<~ERB
        <%= link_to href, class: classes do %>
          <%= content %>
        <% end %>
      ERB
    end
  end
end
