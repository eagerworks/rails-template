# frozen_string_literal: true

module Form
  # @display component_path form/select
  class SelectPreview < ViewComponent::Preview
    def options_array; end

    def slots; end

    # @param color color
    def custom_color(color: '#059669')
      render_with_template(locals: { color: color })
    end
  end
end
