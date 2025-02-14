module Authorization
  extend ActiveSupport::Concern

  def verify_pundit_authorization
    return if devise_controller? || active_admin_controller?

    if collection_action
      verify_policy_scoped
    else
      verify_authorized
    end
  end

  def load_and_authorize_resource
    if collection_action
      load_resource
    elsif %w[new create].include?(action_name)
      build_resource
      authorize(@resource)
    else
      load_resource
      authorize(@resource)
    end
  end

  def build_resource
    @resource = resource_class.new

    if respond_to?("#{resource_name}_params", true) && params[resource_name].present?
      @resource.assign_attributes(send("#{resource_name}_params"))
    end

    instance_variable_set("@#{resource_name}", @resource)
  end

  def load_resource
    @resource = if collection_action
                  policy_scope(resource_class)
                else
                  resource_class.find(resource_id)
                end

    instance_variable_set("@#{resource_name}", @resource)
  end

  def resource_name
    if collection_action
      controller_name
    else
      controller_name.singularize
    end
  end

  def collection_action
    action_name == 'index'
  end

  def resource_class
    controller_name.classify.constantize
  end

  def resource_id
    params[:id] || params["#{resource_name}_id"]
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}", scope: 'pundit', default: :default
    redirect_back_or_to(root_path)
  end

  def admin_not_authorized(exception)
    flash[:error] = exception.message
    redirect_back_or_to(root_path)
  end
end
