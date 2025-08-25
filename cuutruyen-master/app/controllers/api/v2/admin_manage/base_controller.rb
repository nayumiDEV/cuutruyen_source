class Api::V2::AdminManage::BaseController < Api::V2::BaseController
  before_action :authorize_admin!

  def authorize_admin!
    unless current_user && current_user.admin?
      raise UnauthorizedError, 'Bạn không có quyền quản trị viên.'
    end
  end
end
