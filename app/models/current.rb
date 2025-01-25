# A word of caution: It's easy to overdo a global singleton like Current and tangle your model as a result.
# Current should only be used for a few, top-level globals, like account, user, and request details.
# The attributes stuck in Current should be used by more or less all actions on all requests.
# If you start sticking controller-specific attributes in there, you're going to create a mess.

class Current < ActiveSupport::CurrentAttributes
  attribute :user, :account

  # resets do
  #   Time.zone = nil
  # end

  # def user=(value)
  #   super
  #   Time.zone = Time.find_zone(value&.time_zone)
  # end

  def account=(value)
    super
    @account_user = nil
    @other_accounts = nil
  end

  def account_user
    return unless account

    @account_user ||= account.account_users.find_by(user: user)
  end

  def role
    account_user&.role
  end

  def account_admin?
    role == 'admin'
  end
end
