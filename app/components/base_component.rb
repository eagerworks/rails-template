# frozen_string_literal: true

class BaseComponent < ViewComponent::Base
  use_helpers :class_list, :primary_color

  attr_reader :attributes

  def initialize(**attributes)
    super

    @attributes = attributes
  end
end
