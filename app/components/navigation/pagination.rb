module Navigation
  class Pagination < ViewComponent::Base
    include Pagy::Frontend

    def initialize(pagy:)
      super

      @pagy = pagy
    end
  end
end
