# frozen_string_literal: true

module Form
  class Input < BaseComponent
    renders_one :description
    renders_one :label, lambda { |&block|
      Label.new(name: name, label: block.call, form: form)
    }

    attr_reader :name, :form, :show_label, :margin, :custom_color

    def initialize(
      name:, form: nil, label: nil, show_label: true, margin: true, custom_colors: {},
      **attributes
    )
      super(**attributes)

      @name = name
      @label = label
      @form = form
      @show_label = show_label
      @margin = margin
      @custom_color = custom_colors[:primary]
    end

    def label(**attributes)
      return super if label?

      render(Label.new(name: name, label: @label, form: form, **attributes))
    end

    def field_id
      form&.field_id(name) || name
    end

    def field_name
      form&.field_name(name) || name
    end

    def input_tag(*args, **kwargs)
      options = kwargs.merge(attributes)
      input_type = self.class.name.demodulize.underscore

      return form.send(input_type, name, *args, **options) if form.present?

      send("#{input_type}_tag", name, value, *args, **options)
    end

    def object
      form&.object
    end

    def object_name
      form&.object_name
    end

    def value
      object&.try(name)
    end

    def error
      object.try(:errors)&.full_messages_for(name)&.first
    end

    def error?
      object.try(:errors)&.include?(name)
    end

    def focus_class
      case primary_color
      when 'indigo'
        'focus:ring-indigo-600'
      when 'aqua'
        'focus:ring-aqua-600'
      end
    end
  end
end
