# frozen_string_literal: true
module Form
  class RadioButtons < Input
    renders_many :options, lambda { |value:, label: nil|
      Option.new(form: @form, name: @name, value: value, label: label, disabled: @disabled)
    }

    def initialize(disabled: false, **attributes)
      super(**attributes)

      @disabled = disabled
    end

    class Option < Input
      attr_reader :value

      def initialize(form:, name:, value:, label:, disabled: false)
        super(name: name, form: form, label: label)

        @disabled = disabled
        @value = value
      end

      def checked
        object&.send(name) == value
      end

      def label
        render(Label.new(name: "#{name}_#{value}", label: @label || value.titleize, form: form))
      end

      erb_template <<~ERB
        <div class="flex items-center">
          <%= form.radio_button name, value, checked: checked, disabled: @disabled, class: 'relative size-4 appearance-none rounded-full border border-gray-300 bg-white before:absolute before:inset-1 before:rounded-full before:bg-white checked:border-indigo-600 checked:bg-indigo-600 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 disabled:border-gray-300 disabled:bg-gray-100 disabled:before:bg-gray-400 forced-colors:appearance-auto forced-colors:before:hidden [&:not(:checked)]:before:hidden' %>
          <div class="ml-3">
            <%= label %>
          </div>
        </div>
      ERB
    end
  end
end
