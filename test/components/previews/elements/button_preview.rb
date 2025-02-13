# frozen_string_literal: true

module Elements
  # @display component_path elements/button
  class ButtonPreview < ViewComponent::Preview
    # @param text
    # @param size select { choices: [xs, sm, md, lg, xl] }
    # @param variant select { choices: [primary, secondary, soft] }
    # @param rounded
    def primary(text: 'Button text', size: :md, variant: :primary, rounded: false)
      render(Elements::Button.new(
        size: size, variant: variant, rounded: rounded
      ).with_content(text))
    end

    # @param text
    # @param size select { choices: [xs, sm, md, lg, xl] }
    # @param variant select { choices: [primary, secondary, soft] }
    # @param rounded
    def secondary(text: 'Button text', size: :md, variant: :secondary, rounded: false)
      render(Elements::Button.new(
        size: size, variant: variant, rounded: rounded
      ).with_content(text))
    end

    # @param text
    # @param size select { choices: [xs, sm, md, lg, xl] }
    # @param variant select { choices: [primary, secondary, soft] }
    # @param rounded
    # @param dark
    # @display dark true
    def dark(text: 'Button text', size: :md, variant: :primary, rounded: false, dark: true)
      render(Elements::Button.new(
        size: size, variant: variant, rounded: rounded, dark: dark
      ).with_content(text))
    end

    # @param text
    # @param size select { choices: [xs, sm, md, lg, xl] }
    # @param variant select { choices: [primary, secondary, soft] }
    # @param rounded
    def soft(text: 'Button text', size: :md, variant: :soft, rounded: false)
      render(Elements::Button.new(
        size: size, variant: variant, rounded: rounded
      ).with_content(text))
    end

    # @param text
    # @param size select { choices: [xs, sm, md, lg, xl] }
    # @param variant select { choices: [primary, secondary, soft] }
    # @param rounded
    def rounded(text: 'Button text', size: :md, variant: :primary, rounded: true)
      render(Elements::Button.new(
        size: size, variant: variant, rounded: rounded
      ).with_content(text))
    end
  end
end
