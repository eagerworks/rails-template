# frozen_string_literal: true

module Form
  # @display component_path form/date_picker
  # @display min_height 500
  class DatePickerPreview < ViewComponent::Preview
    def default
      render(Form::DatePicker.new(name: 'date'))
    end
  end
end
