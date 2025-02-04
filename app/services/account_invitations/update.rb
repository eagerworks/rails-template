module AccountInvitations
  class Update < ApplicationService
    def call(invitation:, params:)
      old_email = invitation.email
      if invitation.update(params)
        if old_email != invitation.email
          AccountMailer.with(invitation: invitation).invitation_email.deliver_later
        end
        success(invitation)
      else
        failure(invitation)
      end
    end
  end
end
