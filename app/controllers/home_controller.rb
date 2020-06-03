class HomeController < ApplicationController
  def index
    redirect_to new_user_session_path unless user_signed_in?
  end

  def buttons; end
  def cards; end
  def cards; end
  def charts; end
  def tables; end
  def utilities_animation; end
  def utilities_border; end
  def utilities_color; end
  def utilities_other; end
end
