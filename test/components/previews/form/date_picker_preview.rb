# frozen_string_literal: true

module Form
  # @display component_path form/date_picker
  # @display min_height 500
  class DatePickerPreview < ViewComponent::Preview
    # @param format select { choices: ['%Y-%m-%d', '%d/%m/%Y'] }
    def default(format: '%Y-%m-%d')
      render_with_template(locals: { format: format })
    end
  end
end
