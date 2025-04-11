module AccountInvitations
  class Accept
    include Interactor

    def call
      ApplicationRecord.transaction do
        account_user.save!
        context.invitation.destroy!
      end
    end

    private

    def account_user
      context.account_user = account.account_users.new(
        user: context.user, role: context.invitation.role
      )
    end

    def account
      context.invitation.account
    end
  end
end
