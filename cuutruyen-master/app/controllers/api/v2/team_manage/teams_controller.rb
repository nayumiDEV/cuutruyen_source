class Api::V2::TeamManage::TeamsController < Api::V2::TeamManage::BaseController
  def show
  end

  def update
    authorize current_team, :advanced_manage?
    @current_team.update(team_params)
    if @current_team.save
      head :accepted
    else
      render 'api/v2/base/error', locals: { message: 'Vui lòng kiểm tra lại nội dung bạn nhập', data: @current_team.errors }, status: :unprocessable_entity
    end
  end

  private

  def team_params
    params
      .require(:team)
      .permit(
        :name,
        :slug,
        :description,
        :facebook_address,
        :main_page_blocks,
        :avatar,
        team_members_attributes: [:id, :user_id, :role, :_destroy]
      )
  end
end
