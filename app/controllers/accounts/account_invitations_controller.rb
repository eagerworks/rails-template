module Accounts
  class AccountInvitationsController < ApplicationController
    layout 'settings'
    before_action :load_account
    before_action :build_invitation, only: [:new, :create]
    before_action :load_invitation, only: [:edit, :update, :resend, :destroy]

    def new; end

    def create
      @account_invitation.assign_attributes(account_invitation_params)

      if @account_invitation.save
        AccountMailer.with(invitation: @account_invitation).invitation_email.deliver_later
        redirect_to account_path(@account), notice: 'Invitation sent successfully'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      result = ::AccountInvitations::Update.call(invitation: @account_invitation,
                                                 params: account_invitation_params)
      if result.success?
        redirect_to account_path(@account_invitation.account),
                    notice: 'Invitation updated successfully'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def resend
      AccountMailer.with(invitation: @account_invitation).invitation_email.deliver_later
      redirect_to account_path(@account), notice: 'Invitation resent successfully'
    end

    def destroy
      @account_invitation.destroy
      redirect_to account_path(@account), notice: 'Invitation removed successfully'
    end

    private

    def load_account
      @account = Account.find(params[:account_id])
    end

    def account_invitation_params
      params.require(:account_invitation).permit(:email, :name, :role)
            .merge(invited_by: current_user)
    end

    def build_invitation
      @account_invitation = @account.account_invitations.new

      authorize @account_invitation
    end

    def load_invitation
      @account_invitation = @account.account_invitations.find_by(token: params[:id])

      authorize @account_invitation
    end
  end
end
