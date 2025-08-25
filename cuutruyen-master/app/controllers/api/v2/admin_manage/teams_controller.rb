class Api::V2::AdminManage::TeamsController < Api::V2::AdminManage::BaseController
  def index
    if params[:q].present?
      @keyword = params[:q]
      @pagy, @teams = pagy(Team.all.where('name ILIKE ?', "%#{@keyword}%").order(:name), items: per_page)
    else
      @pagy, @teams = pagy(Team.all.order(created_at: :desc), items: per_page)
    end
  end

  def create
    @team = Team.new team_params

    if @team.save
      render status: :created
    else
      render 'api/v2/base/error', locals: { message: 'Vui lòng kiểm tra lại nội dung bạn nhập', data: @team.errors }, status: :unprocessable_entity
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :description, :facebook_address, team_members_attributes: [:id, :user_id, :role, :destroy])
  end
end
