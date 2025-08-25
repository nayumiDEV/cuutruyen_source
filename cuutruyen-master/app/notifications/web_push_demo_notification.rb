class WebPushDemoNotification < Noticed::Base
  deliver_by :web_push_demo, class: "DeliveryMethods::WebPushDemo"

  def web_push_message
    {
      title: 'Thử nghiệm thông báo',
      body: 'Tính năng đẩy thông báo đang hoạt động bình thường 🎉',
      icon: '/images/icons/favicon-32x32.png',
      badge: '/images/icons/favicon-32x32.png',
      url: '/configuration'
    }
  end
end
