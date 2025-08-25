class Api::V2::CommentsController < Api::V2::BaseController
  def remove
    @comment = Comment.find params[:id]
    authorize @comment
    @comment.remove_reason = comment_removal_params['remove_reason']
    @comment.removed_at = Time.now
    @comment.remover = current_user
    if @comment.save
      invalidate_comments_cache(@comment.commentable_id, @comment.commentable_type)
    end
    head :accepted
  rescue ActiveRecord::RecordNotFound
    raise NotFoundError, 'Không tìm thấy bình luận bạn đang muốn gỡ bỏ'
  rescue Pundit::NotAuthorizedError
    raise UnauthorizedError, 'Bạn không có quyền gỡ bỏ bình luận này'
  end

  def destroy
    @comment = Comment.find params[:id]
    authorize @comment
    if @comment.destroy
      invalidate_comments_cache(@comment.commentable_id, @comment.commentable_type)
    end
    head :accepted
  rescue ActiveRecord::RecordNotFound
    raise NotFoundError, 'Không tìm thấy bình luận bạn đang muốn xóa'
  rescue Pundit::NotAuthorizedError
    raise UnauthorizedError, 'Bạn không có quyền xóa bình luận này'
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def comment_removal_params
    params.require(:comment).permit(:remove_reason)
  end

  def invalidate_comments_cache(commentable_id, commentable_type = nil)
    return unless commentable_id
    
    # If commentable_type is not provided, try to find it from the comment
    if commentable_type.nil? && @comment&.commentable_type.present?
      commentable_type = @comment.commentable_type
    end
    
    # Generate cache key based on commentable type
    cache_key = case commentable_type
                when 'Chapter'
                  "chapter_comments_#{commentable_id}"
                when 'TeamPost'
                  "team_post_comments_#{commentable_id}"
                else
                  return # Unknown commentable type, nothing to invalidate
                end
    
    # Invalidate the cache
    Rails.cache.delete(cache_key)
  end
end
