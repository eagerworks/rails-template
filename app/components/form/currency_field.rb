# frozen_string_literal: true

module Form
  class CurrencyField < TextField
    def classes
      class_list(super, 'pl-7 pr-12')
    end
  end
end
