module ViewComponentHelper
  Dir.glob(Rails.root.join('app/components/**/*.rb')).each do |file|
    root_dir = Rails.root.join('app/components')
    relative_path = Pathname.new(file).relative_path_from(root_dir)
    component_class = relative_path.to_s.gsub('.rb', '').camelize.constantize
    component_name = File.basename(file, '.rb')

    unless /_component\Z/ =~ component_name
      component_name = "#{component_name}_component"
    end

    define_method(component_name) do |*args, **kwargs, &block|
      component_class.new(*args, **kwargs).render_in(self, &block)
    end
  end

  def component_form_with(**options, &block)
    form_with(**options.merge(builder: FormBuilder), &block)
  end

  def button_component_to(content, path, method: nil, **kwargs)
    form_with(url: path, method: method) do
      Elements::Button.new(**kwargs).with_content(content).render_in(self)
    end
  end
end
