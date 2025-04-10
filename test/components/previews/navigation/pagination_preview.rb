# frozen_string_literal: true

module Navigation
  # @display component_path navigation/pagination
  class PaginationPreview < ViewComponent::Preview
    def default
      pagy = Pagy.new(count: 500, page: 1, limit: 10)

      render(Navigation::Pagination.new(pagy: pagy))
    end
  end
end
