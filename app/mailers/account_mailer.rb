class AccountMailer < ApplicationMailer
  def invitation_email
    @account_invitation = params[:invitation]
    @inviter = @account_invitation.invited_by
    @account = @account_invitation.account

    mail(
      to: @account_invitation.email,
      subject: "#{@inviter.full_name} invited you to #{@account.name}"
    )
  end
end
