class AccountUsersController < ApplicationController
  layout 'settings'
  before_action :load_account_user

  def edit
    @account = @account_user.account
  end

  def update
    @account = @account_user.account
    
    if @account_user.update(account_user_params)
      redirect_to account_path(@account_user.account),
                  notice: 'Account user was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account_user.destroy

    redirect_to account_path(@account_user.account),
                notice: 'Account user was successfully removed.'
  end

  private

  def account_user_params
    params.require(:account_user).permit(:role)
  end

  def load_account_user
    @account_user = authorize(AccountUser.find(params[:id]))
  end
end
