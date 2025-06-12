class FriendsController < ApplicationController
  before_action :load_and_authorize_resource

  def index
  end

  def create
    if @friend.save
      redirect_to friends_path, notice: 'Friend was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
  end

  def edit
  end

  def update
  end

  def destroy
    @friend.destroy
    redirect_to friends_path, notice: 'Friend was successfully deleted.'
  rescue ActiveRecord::RecordNotDestroyed
    redirect_to friends_path, alert: 'Failed to delete friend.'
  end

  def show
  end

  private

  def friend_params
    params.require(:friend).permit(:name, :description, :birth_date, :user_id, :best_friend, :awards, :height, :gender)
  end
end
