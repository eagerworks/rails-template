# frozen_string_literal: true

module Form
  class Toggle < Input
    def checked_class
      case primary_color
      when 'indigo'
        'bg-indigo-600'
      when 'aqua'
        'bg-aqua-600'
      end
    end
  end
end
