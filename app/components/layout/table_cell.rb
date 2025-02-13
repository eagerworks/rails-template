# frozen_string_literal: true

module Layout
  class TableCell < BaseComponent
    def initialize(align: :center, truncate: false)
      super()

      @align = align
      @truncate = truncate
    end

    def full_content
      return unless @truncate

      content
    end

    def truncated_content
      if @truncate
        truncate(content, length: 80)
      else
        content
      end
    end

    def align_class
      case @align
      when :left
        'text-left'
      when :right
        'text-right'
      else
        'text-center'
      end
    end
  end
end
