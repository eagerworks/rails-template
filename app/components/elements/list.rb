# frozen_string_literal: true

module Elements
  class List < Base
    renders_many :items, 'Item'

    class Item < Base
      erb_template '<li class="px-6 py-3 hover:bg-gray-50"><%= content %></li>'
    end
  end
end
