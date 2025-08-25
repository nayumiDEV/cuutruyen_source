class Api::V2::TeamManage::TeamPostsController < Api::V2::TeamManage::BaseController
  def index
    authorize current_team, :simple_manage?
    @team_posts = current_team.team_posts.order(created_at: :desc)
    @pagy, @team_posts = pagy(@team_posts, items: per_page)
  end

  def show
    authorize current_team, :simple_manage?
    @team_post = current_team.team_posts.find(params[:id])
  end

  def create
    authorize current_team, :advanced_manage?
    @team_post = current_team.team_posts.new(team_post_params)
    if @team_post.save
      head :created
    else
      raise UnprocessableEntityError.new('Vui lòng kiểm tra lại nội dung bạn nhập', @team_post.errors)
    end
  end

  def update
    authorize current_team, :advanced_manage?
    @team_post = current_team.team_posts.find(params[:id])
    if @team_post.update(team_post_params)
      head :accepted
    else
      raise UnprocessableEntityError.new('Vui lòng kiểm tra lại nội dung bạn nhập', @team_post.errors)
    end
  end

  def destroy
    authorize current_team, :advanced_manage?
    @team_post = current_team.team_posts.find(params[:id])
    @team_post.destroy
    head :accepted
  end

  private

  def team_post_params
    params.require(:team_post).permit(:content)
  end
end
