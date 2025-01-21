# frozen_string_literal: true

module Elements
  class Button < Base
    attr_reader :variant, :rounded, :size, :color, :width

    def initialize(
      variant: :primary, rounded: false, size: :md, color: :indigo, width: :content, **attributes
    )
      super(**attributes)

      @variant = variant.to_sym
      @rounded = rounded
      @size = size.to_sym
      @color = color.to_sym
      @width = width.to_sym
    end

    private

    def classes
      class_list(
        'font-semibold shadow-sm inline-block',
        'focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2',
        size_classes,
        color_classes,
        radius_classes,
        'focus-visible:outline-indigo-600': color == :indigo,
        'focus-visible:outline-red-600': color == :red,
        'w-full': width == :full
      )
    end

    def radius_classes
      return 'rounded-full' if rounded

      case size
      when :xs, :sm
        'rounded'
      when :md, :lg, :xl
        'rounded-md'
      end
    end

    # rubocop:disable Metrics/AbcSize
    def size_classes
      case size
      when :xs
        class_list('py-1 text-xs', 'px-2': !rounded, 'px-2.5': rounded)
      when :sm
        class_list('py-1 text-sm', 'px-2': !rounded, 'px-2.5': rounded)
      when :md
        class_list('py-1.5 text-sm', 'px-2.5': !rounded, 'px-3': rounded)
      when :lg
        class_list('py-2 text-sm', 'px-3': !rounded, 'px-3.5': rounded)
      when :xl
        class_list('py-2.5 text-sm', 'px-3.5': !rounded, 'px-4': rounded)
      end
    end
    # rubocop:enable Metrics/AbcSize

    def color_classes
      if variant == :secondary
        return 'bg-white text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-gray-50'
      end

      if variant == :soft
        return class_list(
          'bg-indigo-50 text-indigo-600 hover:bg-indigo-100': color == :indigo,
          'bg-red-50 text-red-600 hover:bg-red-100': color == :red
        )
      end

      class_list(
        'text-white',
        'bg-indigo-600 hover:bg-indigo-500': color == :indigo,
        'bg-red-600 hover:bg-red-500': color == :red
      )
    end
  end
end
