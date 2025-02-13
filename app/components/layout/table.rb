# frozen_string_literal: true

module Layout
  class Table < BaseComponent
    renders_many :headers, 'Layout::TableHeader'
  end
end
