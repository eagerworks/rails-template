class AccountInvitationsController < ApplicationController
  before_action :load_invitation
  before_action :authenticate_user_with_invite!
  before_action :check_invitation_status

  def show
    skip_authorization

    @account = @account_invitation.account
    @inviter = @account_invitation.invited_by
  end

  def update
    skip_authorization

    result = ::AccountInvitations::Accept.call(invitation: @account_invitation, user: current_user)

    if result.success?
      redirect_to accounts_path
    else
      redirect_to account_invitation_path(@account_invitation), alert: result.error
    end
  end

  def destroy
    skip_authorization

    @account_invitation.destroy!
    redirect_to root_path, notice: 'Invitation declined'
  end

  private

  def load_invitation
    @account_invitation = AccountInvitation.find_by(token: params[:id])

    return if @account_invitation

    flash.alert = 'Invalid invitation token'
    redirect_to root_path
  end

  def authenticate_user_with_invite!
    return if user_signed_in?

    store_location_for(:user, request.fullpath)
    flash.alert = 'Please login or create an account to accept this invitation'
    redirect_to new_user_registration_path(invite: @account_invitation.token)
  end

  def check_invitation_status
    return unless @account_invitation.account.users.include?(current_user)

    flash.alert = 'You are already a member of this account'
    redirect_to accounts_path
  end
end
