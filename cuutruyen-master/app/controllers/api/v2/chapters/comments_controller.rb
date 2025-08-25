module Api::V2::Chapters
  class CommentsController < Api::V2::BaseCommentsController
    before_action :find_commentable, only: [:index, :create]

    def index
      # Cache key includes chapter_id - kept indefinitely with manual invalidation
      cache_key = "chapter_comments_#{@commentable.id}"
      
      @comments = Rails.cache.fetch(cache_key) do
        @commentable
          .comments.includes(:replies, :replieds, user: [:teams, :user_ban])
          .order(:created_at)
          .to_a # Convert to array to cache the actual data
      end
    rescue ActiveRecord::RecordNotFound
      raise NotFoundError, 'Không tìm thấy chương truyện bạn đang truy xuất'
    end

    def create
      authorize Comment, :create?

      build_comment

      if @comment.save
        # Invalidate comments cache for this chapter
        invalidate_comments_cache(@commentable.id)
        head :created
      else
        raise UnprocessableEntityError.new('Vui lòng kiểm tra lại nội dung bạn nhập', @comment.errors)
      end
    rescue ActiveRecord::RecordNotFound
      raise NotFoundError, 'Không tìm thấy chương truyện bạn đang truy xuất'
    end

    def remove
      @comment = Comment.find params[:id]
      authorize @comment

      @comment.remove_reason = comment_removal_params['remove_reason']
      @comment.removed_at = Time.now
      @comment.remover = current_user
      
      if @comment.save
        # Invalidate comments cache for the chapter this comment belongs to
        chapter_id = @comment.commentable_id if @comment.commentable_type == 'Chapter'
        invalidate_comments_cache(chapter_id) if chapter_id
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
      
      # Store chapter_id before destroying the comment
      chapter_id = @comment.commentable_id if @comment.commentable_type == 'Chapter'
      
      @comment.destroy
      
      # Invalidate comments cache for the chapter this comment belonged to
      invalidate_comments_cache(chapter_id) if chapter_id
      
      head :accepted
    rescue ActiveRecord::RecordNotFound
      raise NotFoundError, 'Không tìm thấy bình luận bạn đang muốn xóa'
    rescue Pundit::NotAuthorizedError
      raise UnauthorizedError, 'Bạn không có quyền xóa bình luận này'
    end

    private

    def find_commentable
      @commentable = Chapter.kept.find(params[:chapter_id])
    end
    
    def invalidate_comments_cache(chapter_id)
      return unless chapter_id
      
      # Invalidate the indefinite cache for this chapter
      cache_key = "chapter_comments_#{chapter_id}"
      Rails.cache.delete(cache_key)
    end
  end
end
