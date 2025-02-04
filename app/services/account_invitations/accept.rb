module AccountInvitations
  class Accept < ApplicationService
    def call(invitation:, user:)
      account = invitation.account
      account_user = account.account_users.new(user: user, role: invitation.role)

      ApplicationRecord.transaction do
        account_user.save!
        invitation.destroy!
      end

      success(account_user)
    end
  end
end
