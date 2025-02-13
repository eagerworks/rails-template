# frozen_string_literal: true

module Form
  class Label < BaseComponent
    attr_reader :form, :name, :label

    def initialize(name:, label: nil, form: nil, **attributes)
      super(**attributes)

      @form = form
      @name = name
      @label = label || name.to_s.titleize
    end

    def classes
      'font-medium text-gray-900 text-sm/6'
    end
  end
end
