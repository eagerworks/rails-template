class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Authorization

  impersonates :user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting,
  # and CSS :has.
  allow_browser versions: :modern
  after_action :verify_pundit_authorization
  before_action :set_request_details

  private

  def require_current_account_admin!
    authenticate_user!

    redirect_to root_path, alert: 'You must be an admin to do that.' unless Current.account_admin?
  end

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
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
