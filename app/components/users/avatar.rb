# frozen_string_literal: true

module Users
  class Avatar < ViewComponent::Base
    def initialize(user:)
      super

      @user = user
    end

    # Gravatar URL generator to get avatar by email
    # See for details: https://en.gravatar.com/site/implement/images/
    def gravatar_url
      hash = Digest::MD5.hexdigest(@user.email&.downcase || '')
      options = { default: :mp, rating: :pg, size: 40 }
      "https://secure.gravatar.com/avatar/#{hash}.png?#{options.to_param}"
    end

    def avatar_url
      return url_for(@user.avatar.variant(:thumb)) if @user.avatar.attached?

      gravatar_url
    end
  end
end
