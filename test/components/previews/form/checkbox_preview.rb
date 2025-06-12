# frozen_string_literal: true

module Form
  # @display component_path form/checkbox
  class CheckboxPreview < ViewComponent::Preview
    # @param label
    # @param margin
    def default(label: 'I agree to the terms and conditions', margin: true)
      render(
        Form::Checkbox.new(
          name: 'checkbox_preview', label: label, margin: margin
        )
      )
    end

    # @param label
    # @param margin
    def with_description(
      label: 'Show Memo', margin: true,
      description: 'Allows the donor to add a custom memo/comment for their donation.'
    )
      render(
        Form::Checkbox.new(
          name: 'checkbox_preview', label: label, margin: margin
        ).with_description_content(description)
      )
    end
  end
end
