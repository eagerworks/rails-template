# frozen_string_literal: true

module ActiveAdmin
  class ActiveAdminPolicy
    attr_reader :user, :record

    delegate :admin?, to: :user

    def initialize(user, record)
      @user = user
      @record = record
    end

    def index?
      admin?
    end

    def show?
      admin?
    end

    def create?
      admin?
    end

    def new?
      create?
    end

    def update?
      admin?
    end

    def edit?
      update?
    end

    def destroy?
      admin?
    end

    class Scope
      def initialize(user, scope)
        @user = user
        @scope = scope
      end

      def resolve
        raise NoMethodError, "You must define #resolve in #{self.class}" unless user.admin?

        scope.all
      end

      private

      attr_reader :user, :scope
    end
  end
end
