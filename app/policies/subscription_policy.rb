class SubscriptionPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def create?
    Current.account_admin?
  end

  def index?
    Current.account_admin? && Current.account.subscribed?
  end

  def show?
    Current.account_admin? && Current.account.subscription == record &&
      (record.active? || record.on_grace_period?)
  end

  def cancel?
    Current.account_admin? && Current.account.subscription == record && record.active?
  end

  def renew?
    Current.account_admin? && Current.account.subscription == record && record.on_grace_period?
  end

  def update?
    Current.account_admin? && Current.account.subscription == record && record.active?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
