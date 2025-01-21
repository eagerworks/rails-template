# frozen_string_literal: true

module Navigation
  # @display component_path navigation/tabs
  class TabsPreview < ViewComponent::Preview
    def default
      render(Navigation::Tabs.new(turbo_frame: :tabs)) do |tabs|
        tabs.with_tab(url: '#', label: 'Tab 1')
        tabs.with_tab(url: '#', label: 'Tab 2')
        tabs.with_tab(url: '#', label: 'Tab 3')
      end
    end
  end
end
