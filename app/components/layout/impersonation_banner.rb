# frozen_string_literal: true

module Layout
  class ImpersonationBanner < ViewComponent::Base
    use_helpers :current_user, :true_user

    def render?
      current_user != true_user
    end
  end
end
