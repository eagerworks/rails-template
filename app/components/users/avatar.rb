# frozen_string_literal: true

module Users
  class Avatar < ViewComponent::Base
    def initialize(user: nil, account: nil)
      super

      @account = account
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
      if @account.present?
        return url_for(@account.avatar.variant(:thumb))
      end

      return url_for(@user.avatar.variant(:thumb)) if @user.avatar.attached?

      gravatar_url
    end

    def initials
      @account.name.split(' ').first(2).map(&:first).join.upcase
    end

    def avatar?
      @user.present? || @account&.avatar&.attached?
    end
  end
end
