
# To deliver this notification:
#
# NewChapterNotification.with(post: @post).deliver_later(current_user)
# NewChapterNotification.with(post: @post).deliver(current_user)

class ReplyNotification < Noticed::Base
  deliver_by :database
  deliver_by :web_push, class: "DeliveryMethods::WebPush"

  # Define helper methods to make rendering easier.
  #
  def message_plain
    "Bạn vừa được #{params[:comment_username]} trả lời trong bình luận ở #{params[:manga_title]} - chapter #{params[:chapter_number]} với nội dung \"#{params[:truncated_content]}\"!"
  end

  def title
    "Bình luận của bạn vừa có thêm trả lời mới!"
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
      badge: '/images/icons/android-chrome-192x192.png',
      url: redirect_url
    }
  end
end
