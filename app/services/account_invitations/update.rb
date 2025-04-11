module AccountInvitations
  class Update
    include Interactor

    def call
      context.old_email = invitation.email
      if invitation.update(context.params)
        notify_user
      else
        context.fail!(error: error_messages)
      end
    end

    private

    def error_messages
      invitation.errors.full_messages.join(', ')
    end

    def invitation
      context.invitation
    end

    def notify_user
      return unless context.old_email != invitation.email

      AccountMailer.with(invitation: invitation).invitation_email.deliver_later
    end
  end
end
