# To deliver this notification:
#
# NewChapterNotification.with(post: @post).deliver_later(current_user)
# NewChapterNotification.with(post: @post).deliver(current_user)

class NewChapterNotification < Noticed::Base
  deliver_by :database
  deliver_by :web_push, class: "DeliveryMethods::WebPush"

  # Define helper methods to make rendering easier.
  #
  def message_plain
    "Truyện #{params[:manga_title]} vừa mới được đăng chapter #{params[:chapter_number]}!"
  end

  def title
    "Truyện bạn theo dõi có chương mới!"
  end

  def icon
    params[:manga_cover_url]
  end

  def redirect_url
    "/notifications/#{record.id}"
  end

  def url
    "/mangas/#{params[:manga_id]}/chapters/#{params[:chapter_id]}"
  end

  def web_push_message
    {
      title: title,
      body: message_plain,
      icon: params[:manga_cover_url],
      image: params[:manga_panorama_url],
      badge: '/images/icons/android-chrome-192x192.png',
      url: redirect_url
    }
  end
end
