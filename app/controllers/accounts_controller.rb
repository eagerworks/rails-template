class AccountsController < ApplicationController
  layout 'settings'

  before_action :authenticate_user!
  before_action :load_and_authorize_resource

  def index; end

  def new; end

  def create
    @account.owner = current_user

    if @account.save
      @account.account_users.create!(user: current_user, role: :admin)
      redirect_to accounts_path, notice: 'Account was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def switch
    session[:account_id] = @account.id
    redirect_to url_from(params[:return_to]) || root_path
  end

  private

  def account_params
    params.require(:account).permit(:name, :avatar)
  end
end
