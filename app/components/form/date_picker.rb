module Form
  class DatePicker < Input
    use_helpers :heroicon

    def initialize(autohide: true, **args)
      super(**args)

      attributes['datepicker-autohide'] = autohide
    end

    private

    def html_attributes
      attributes.keys.select { |key| attributes[key] }.join(' ')
    end

    def classes
      class_list(
        'block w-full rounded-md bg-white px-3 pl-10 py-1.5 text-base',
        'ring-1 ring-inset border-0',
        'focus:ring-2 placeholder:text-base placeholder:sm:text-sm/6',
        'sm:text-sm/6',
        'disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-gray-500',
        'disabled:ring-gray-200',
        'text-red-900 ring-red-300 placeholder:text-red-300 focus:ring-red-600': error?,
        'text-gray-900 ring-gray-300 placeholder:text-gray-400': !error?,
        'focus:ring-indigo-600': !error?
      )
    end
  end
end
