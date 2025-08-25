class Api::V2::TeamManage::BaseController < Api::V2::BaseController
  before_action :current_team

  def current_team
    if @current_team.present?
      @current_team
    else
      @current_team = Team.find params[:team_id]
      authorize @current_team, :simple_manage?

      @current_team
    end
  rescue ActiveRecord::RecordNotFound, Pundit::NotAuthorizedError
    raise UnauthorizedError, 'Bạn không có quyền quản lý nhóm này.'
  end
end
