module Form
  # @display component_path form/nested_fields
  # @display min_height 700
  class NestedFieldsPreview < ViewComponent::Preview
    def default
      user = User.first
      render_with_template(locals: { user: user })
    end
  end
end
