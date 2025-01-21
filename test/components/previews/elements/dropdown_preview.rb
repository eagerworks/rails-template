# frozen_string_literal: true

module Elements
  # @display component_path elements/dropdown
  class DropdownPreview < ViewComponent::Preview
    # @param content
    # @param align select [left, right]
    def default(content: 'Options', align: :left)
      render_with_template(locals: { content: content, align: align })
    end
  end
end
