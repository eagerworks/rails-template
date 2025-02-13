class PlansController < ApplicationController
  def index
    @plans = policy_scope(Plan).where(interval: params[:interval] || 'monthly').order(:amount)
  end
end
