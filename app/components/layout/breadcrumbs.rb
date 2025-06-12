# frozen_string_literal: true

module Layout
  class Breadcrumbs < BaseComponent
    use_helpers :heroicon
    renders_many :items, 'BreadcrumbItem'

    class BreadcrumbItem < BaseComponent
      use_helpers :heroicon

      def initialize(href: nil)
        super

        @href = href
      end

      erb_template <<~ERB
        <li>
          <div class="flex items-center">
            <%= heroicon('chevron-right', options: { class: 'size-5 text-gray-400' }) %>
            <%= link_to @href, class: 'ml-4 text-sm font-medium text-gray-500 hover:text-gray-700' do %>
              <%= content %>
            <% end %>
          </div>
        </li>
      ERB
    end
  end
end
