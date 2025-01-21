# frozen_string_literal: true

module Layout
  class Table < Base
    renders_many :headers, 'Layout::TableHeader'
  end
end
