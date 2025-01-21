# frozen_string_literal: true

module Form
  # @display component_path form/toggle
  class TogglePreview < ViewComponent::Preview
    def default; end

    # @param label
    # @param description
    def with_label(
      label: 'Available',
      description: 'Nulla amet tempus sit accumsan. Aliquet turpis sed sit lacinia.'
    )
      render_with_template(locals: { label: label, description: description })
    end
  end
end
