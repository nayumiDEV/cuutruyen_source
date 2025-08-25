class DeliveryMethods::WebPushDemo < Noticed::DeliveryMethods::Base
  def deliver
    # Logic for sending the notification
    send_web_push
  end


  # You may override this method to validate options for the delivery method
  # Invalid options should raise a ValidationError
  #
  # def self.validate!(options)
  #   raise ValidationError, "required_option missing" unless options[:required_option]
  # end
  private

  def send_web_push
    message = notification.web_push_message

    Webpush.payload_send(
      vapid: {
        subject: 'mailto:tranthang.yb@outlook.com',
        public_key: ENV['VAPID_PUBLIC_KEY'],
        private_key: ENV['VAPID_PRIVATE_KEY']
      },
      endpoint: params[:endpoint_url],
      auth: params[:auth],
      p256dh: params[:p256dh],
      message: JSON.generate(message)
    )
  rescue Webpush::ExpiredSubscription
  end
end
