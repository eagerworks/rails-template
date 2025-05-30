# To deliver this notification:
#
# NewSubscriptionNotifier.with(record: @post, message: "New post").deliver(User.all)

class NewSubscriptionNotifier < ApplicationNotifier
  deliver_by :turbo_stream, class: 'DeliveryMethods::TurboStream' do |config|
    config.show_toast = true
  end

  required_param :subscription

  notification_methods do
    def title
      "#{account.name}'s subscription plan has been updated"
    end

    def subtitle
      "The #{account.name} account has updated their subscription plan to #{plan.name}."
    end

    def url
      subscriptions_path
    end

    def account
      params[:subscription].account
    end

    def plan
      params[:subscription].plan
    end
  end
end
