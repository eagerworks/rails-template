# frozen_string_literal: true

module Layout
  class Card < Base
    renders_one :header
    renders_one :footer

    def initialize(padding: :md, color: nil)
      super()

      @color = color
      @padding = padding
    end

    def padding_classes
      case @padding
      when :md
        'px-4 py-5 sm:p-6'
      when :lg
        'px-6 py-12 sm:px-12'
      else
        ''
      end
    end

    def classes
      # Add possible classes as comments for tailwind to compile them

      # bg-green-100 border-green-400 text-green-700
      # bg-red-100 border-red-400 text-red-700

      class_list(
        'overflow-hidden divide-y divide-gray-200 sm:rounded-lg shadow border',
        'bg-white border-black border-opacity-5': @color.nil?,
        "bg-#{@color}-100 border-#{@color}-400 text-#{@color}-700": @color.present?
      )
    end
  end
end
