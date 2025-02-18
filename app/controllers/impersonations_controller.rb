class ImpersonationsController < ApplicationController
  def destroy
    authorize :impersonation
    stop_impersonating_user
    redirect_back(fallback_location: root_path)
  end

  private

  def pundit_user
    true_user
  end
end
