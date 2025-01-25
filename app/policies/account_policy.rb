class AccountPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def belongs_to_account?
    record.account_users.where(user: user).exists?
  end

  def create?
    true
  end

  def switch?
    belongs_to_account?
  end

  def show?
    belongs_to_account?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.joins(:account_users).where(account_users: { user_id: user.id })
    end
  end
end
