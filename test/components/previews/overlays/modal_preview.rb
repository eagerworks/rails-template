# frozen_string_literal: true

module Overlays
  # @display component_path overlays/modal
  # @display min_height 500
  class ModalPreview < ViewComponent::Preview
    def default; end

    def turbo
      render_with_template(locals: { users: User.first(3) })
    end
  end
end
