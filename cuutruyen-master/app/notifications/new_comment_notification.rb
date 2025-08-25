# To deliver this notification:
#
# NewChapterNotification.with(post: @post).deliver_later(current_user)
# NewChapterNotification.with(post: @post).deliver(current_user)

class NewCommentNotification < Noticed::Base
  deliver_by :database

  # Define helper methods to make rendering easier.
  #
  def message_plain
    "#{params[:comment_username]} vừa thêm bình luận mới ở truyện #{params[:manga_title]} - chapter #{params[:chapter_number]} với nội dung \"#{params[:truncated_content]}\"!"
  end

  def title
    "Bình luận mới ở truyện của nhóm bạn!"
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
end
