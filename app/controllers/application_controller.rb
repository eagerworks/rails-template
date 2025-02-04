class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting,
  # and CSS :has.
  allow_browser versions: :modern
  after_action :verify_pundit_authorization
  before_action :set_request_details

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
  end

  def verify_pundit_authorization
    return if devise_controller? || active_admin_controller?

    if action_name == 'index'
      verify_policy_scoped
    else
      verify_authorized
    end
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

  def set_request_details
    Current.user = current_user

    # Account may already be set by the AccountMiddleware
    Current.account ||= account_from_param || account_from_session || fallback_account

    set_current_tenant(Current.account) if defined? ActsAsTenant
  end

  def account_from_session
    return unless user_signed_in? && (account_id = session[:account_id])

    current_user.accounts.find_by(id: account_id)
  end

  def account_from_param
    return unless user_signed_in? && (account_id = params[:account_id].presence)

    current_user.accounts.find_by(id: account_id)
  end

  # Returns an account sorting by personal accounts and oldest account first
  def fallback_account
    return unless user_signed_in?

    current_user.accounts.order(personal: :desc,
                                created_at: :asc).first || current_user.create_default_account
  end
end
