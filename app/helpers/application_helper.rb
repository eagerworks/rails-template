module ApplicationHelper
  def class_list(*args, **kwargs)
    conditional_classes = kwargs.keys.select { |key| kwargs[key] }
    class_list = args + conditional_classes
    class_list.join(' ')
  end
end
