# frozen_string_literal: true

module Elements
  class List < BaseComponent
    renders_many :items, 'Item'

    class Item < BaseComponent
      erb_template '<li class="px-6 py-3 hover:bg-gray-50"><%= content %></li>'
    end
  end
end
