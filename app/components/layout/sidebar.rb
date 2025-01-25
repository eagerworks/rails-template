# frozen_string_literal: true

module Layout
  class Sidebar < Base
    renders_many :items, 'SidebarItem'

    class SidebarItem < Base
      def initialize(href:, controllers: [])
        super

        @controllers = controllers
        @href = href
      end

      def current?
        current_page?(@href) || @controllers.any? { |controller| controller_name == controller }
      end

      def classes
        class_list(
          'text-gray-700 hover:text-indigo-600 hover:bg-gray-50': !current?,
          'bg-gray-50 text-indigo-600': current?
        )
      end

      erb_template <<~ERB
        <li>
          <a href="<%= @href %>" class="group flex gap-x-3 rounded-md py-2 pl-2 pr-3 text-sm/6 font-semibold <%= classes %>">
            <%= content %>
          </a>
        </li>
      ERB
    end
  end
end
