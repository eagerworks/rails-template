# frozen_string_literal: true

module Form
  class Select < Input
    renders_many :options, 'Option'

    def initialize(
      collection: nil, options: [], value_method: :id, label_method: :name, selected: nil,
      **attributes
    )
      super(**attributes)

      @value_method = value_method
      @label_method = label_method
      @collection = collection
      @options = options
      @selected = selected
    end

    def collection_options
      if @collection.present?
        options_from_collection_for_select(@collection, @value_method, @label_method, @selected)
      else
        options_for_select(@options, @selected)
      end
    end

    def rendered_options
      if options?
        rendered_options = options.map do |option|
          option.render_in(view_context)
        end
        safe_join(rendered_options)
      else
        collection_options
      end
    end

    class Option < Base
      attr_reader :value, :label, :selected

      def initialize(value:, label:, selected: false)
        super()

        @value = value
        @label = label
        @selected = selected
      end

      erb_template <<~ERB
        <option value="<%= value %>"<%= ' selected' if selected %>><%= label %></option>
      ERB
    end
  end
end
