# frozen_string_literal: true

module Elements
  # @display component_path elements/link
  class LinkPreview < ViewComponent::Preview
    # @param text
    def default(text: 'Link text')
      render(Elements::Link.new(
        href: '#'
      ).with_content(text))
    end
  end
end
