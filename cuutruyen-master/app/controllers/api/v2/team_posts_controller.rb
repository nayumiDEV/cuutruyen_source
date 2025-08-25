class Api::V2::TeamPostsController < Api::V2::BaseController
  def index
    @team = Team.find_by(id: params[:team_id])
    raise NotFoundError, 'Nhóm bạn đang cố gắng truy cập không tồn tại' unless @team.present?
    @team_posts = @team.team_posts.order(created_at: :desc)
    @pagy, @team_posts = pagy(@team_posts, items: per_page)
  end
end
