# frozen_string_literal: true

module Layout
  class Card < BaseComponent
    renders_one :header
    renders_one :footer

    def initialize(padding: :md)
      super()

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
      class_list(
        'overflow-hidden divide-y divide-gray-200 sm:rounded-lg shadow border',
        'bg-white border-black border-opacity-5'
      )
    end
  end
end
