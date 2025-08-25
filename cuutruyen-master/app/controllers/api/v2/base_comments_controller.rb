class Api::V2::BaseCommentsController < Api::V2::BaseController
  protected

  def find_commentable
    # This should be implemented by subclasses
    raise NotImplementedError
  end

  def build_comment
    @comment = Comment.new(comment_params)
    @comment.commentable = @commentable
    @comment.user = current_user
    @comment.is_shadow_removed = !!current_user&.user_ban&.shadow_ban?

    # Set translation if commentable is a Chapter
    if @commentable.is_a?(Chapter)
      @comment.translation = @commentable.translation
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def comment_removal_params
    params.require(:comment).permit(:remove_reason)
  end
end
