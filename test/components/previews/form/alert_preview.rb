# frozen_string_literal: true

module Form
  # @display component_path form/alert
  class AlertPreview < ViewComponent::Preview
    # @param type select [alert, error, notice, info]
    def default(type: 'alert')
      render(Form::Alert.new(
        type: type
      ).with_content('Alert Text'))
    end

    # @param title
    # @param type select [alert, error, notice, info]
    def with_title(title: 'Attention needed', type: 'alert')
      render(
        Form::Alert.new(type: type)
      ) do |alert|
        alert.with_title_content(title)
        'Lorem ipsum dolor sit amet consectetur adipisicing elit. ' \
          'Aliquid pariatur, ipsum similique veniam quo totam eius aperiam dolorum.'
      end
    end
  end
end
