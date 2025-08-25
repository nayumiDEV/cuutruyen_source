class DeliveryMethods::WebPush < Noticed::DeliveryMethods::Base
  def deliver
    # Logic for sending the notification

    user = recipient

    endpoints = user.web_push_endpoints

    endpoints.each do |ep|
      send_web_push ep
    end
  end


  # You may override this method to validate options for the delivery method
  # Invalid options should raise a ValidationError
  #
  # def self.validate!(options)
  #   raise ValidationError, "required_option missing" unless options[:required_option]
  # end
  private

  def send_web_push ep
    message = notification.web_push_message

    Webpush.payload_send(
      vapid: {
        subject: 'mailto:tranthang.yb@outlook.com',
        public_key: ENV['VAPID_PUBLIC_KEY'],
        private_key: ENV['VAPID_PRIVATE_KEY']
      },
      endpoint: ep.endpoint_url,
      auth: ep.auth,
      p256dh: ep.p256dh,
      ttl: 259200,
      message: JSON.generate(message)
    )
  rescue Webpush::ExpiredSubscription, Webpush::ResponseError
    ep.destroy
  end
end
