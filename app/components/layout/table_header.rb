# frozen_string_literal: true

module Layout
  class TableHeader < Base
    def initialize(align: :center)
      super()

      @align = align
    end

    erb_template <<~ERB
      <th scope="col" class="sm:px-6 px-4 py-3.5 text-sm font-semibold text-gray-900 text-<%= @align %>">
        <%= content %>
      </th>
    ERB
  end
end
