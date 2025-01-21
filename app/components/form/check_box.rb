# frozen_string_literal: true

module Form
  class CheckBox < Input
    use_helpers :check_box
    attr_reader :checked_value, :unchecked_value

    def initialize(checked_value: '1', unchecked_value: '0', name: nil, **attributes)
      super(name: name, **attributes)

      @checked_value = checked_value
      @unchecked_value = unchecked_value
    end
  end
end
