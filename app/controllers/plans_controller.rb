class PlansController < ApplicationController
  before_action :load_and_authorize_resource

  def index
    @plans = @plans.where(interval: params[:interval] || 'monthly').order(:amount)
  end
end
