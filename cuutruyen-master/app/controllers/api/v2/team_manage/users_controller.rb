class Api::V2::TeamManage::UsersController < Api::V2::TeamManage::BaseController
  def search
    @keyword = params[:q]
    per_page = if params[:per_page]
                 params[:per_page].to_i.clamp(5, 50)
               else
                 24
               end
    @pagy, @users = pagy(User.all.where('username ILIKE ?', "#{@keyword}%").order(:username), items: per_page)
  end
end
