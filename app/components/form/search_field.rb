# frozen_string_literal: true

module Form
  class SearchField < TextField
    use_helpers :heroicon

    def classes
      class_list(super, 'pr-3 pl-10')
    end
  end
end
