# frozen_string_literal: true

module Elements
  class Dropdown < BaseComponent
    renders_one :button

    def initialize(align: :left, label: '')
      super()

      @label = label
      @align = align
    end

    def focus_classes
      class_list(
        'focus-visible:outline focus-visible:outline-2',
        'focus-visible:outline-offset-2',
        'focus-visible:outline-indigo-600'
      )
    end

    def align_classes
      case @align
      when :left
        'origin-top-left left-0'
      when :right
        'origin-top-right right-0'
      end
    end
  end
end
