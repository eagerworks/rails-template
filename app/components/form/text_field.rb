# frozen_string_literal: true

module Form
  class TextField < Input
    use_helpers :text_field, :heroicon
    renders_one :left_icon
    renders_one :right_icon

    attr_reader :size

    def initialize(size: 'md', **args)
      super(**args)

      @size = size.to_s
    end

    def classes
      class_list(
        'block w-full rounded-md bg-white px-3 py-1.5 text-base',
        'ring-1 ring-inset border-0',
        'focus:ring-2 placeholder:text-base placeholder:sm:text-sm/6',
        'sm:text-sm/6',
        'disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-gray-500',
        'disabled:ring-gray-200',
        'pr-10': right_icon? || error?,
        'pl-10': left_icon?,
        'text-red-900 ring-red-300 placeholder:text-red-300 focus:ring-red-600': error?,
        'text-gray-900 ring-gray-300 placeholder:text-gray-400': !error?,
        'focus:ring-indigo-600': !error?
      )
    end
  end
end
