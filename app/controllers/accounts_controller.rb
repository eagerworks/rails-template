class AccountsController < ApplicationController
  layout 'settings'

  before_action :load_account, only: [:show, :switch]

  def index
    @accounts = policy_scope(Account)
  end

  def new
    @account = Account.new

    authorize @account
  end

  def create
    @account = Account.new(account_params.merge(owner: current_user))

    authorize @account

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

  def load_account
    id = params[:id] || params[:account_id]
    @account = authorize(Account.find(id))
  end

  def account_params
    params.require(:account).permit(:name, :avatar)
  end
end
