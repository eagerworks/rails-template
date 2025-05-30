module DeliveryMethods
  class TurboStream < ApplicationDeliveryMethod
    # Specify the config options your delivery method requires in its config block
    required_options :show_toast

    def deliver
      return unless recipient.is_a?(User)

      broadcast_update_to_bulletin_board
      broadcast_append_to_toast
    end

    private

    def broadcast_update_to_bulletin_board
      Turbo::StreamsChannel.broadcast_replace_to(
        recipient, :notifications,
        target: :notifications,
        partial: 'layouts/bulletin_board',
        locals: {
          current_user: recipient
        }
      )
    end

    def broadcast_append_to_toast
      return unless config.show_toast

      Turbo::StreamsChannel.broadcast_append_to(
        [recipient, :toasts],
        target: :toasts,
        html: rendered_notification
      )
    end

    def rendered_notification
      ApplicationController.render(
        Notifications::Toast.new(notification: notification),
        layout: false
      )
    end
  end
end
