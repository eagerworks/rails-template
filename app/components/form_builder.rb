# frozen_string_literal: true

class FormBuilder < ActionView::Helpers::FormBuilder
  def method_missing(method_name, *args, **kwargs, &block)
    super and return unless method_name =~ /_component$/

    component_name = method_name.to_s.gsub('_component', '')
    method_class = "Form::#{component_name.camelize}".constantize

    self.class.define_method(method_name) do |name, *component_args, **kw_args, &component_block|
      method_class.new(*component_args, name: name, form: self, **kw_args)
                  .render_in(@template, &component_block)
    end

    send(method_name, *args, **kwargs, &block)
  rescue NameError => e
    if e.message.include?("uninitialized constant Form::#{component_name.camelize}")
      raise NameError, "missing form component: Form::#{component_name.camelize}"
    end

    raise e
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name =~ /_component$/ || super
  end
end
