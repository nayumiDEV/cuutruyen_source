class Api::V2::AdminManage::UsersController < Api::V2::AdminManage::BaseController
  def index
    if params[:q].present?
      @keyword = params[:q]
      @pagy, @users = pagy(User.all.includes(:user_ban).where('username ILIKE ? OR email ILIKE ?', "%#{@keyword}%", "%#{@keyword}%").order(:username), items: per_page)
    else
      @pagy, @users = pagy(User.all.includes(:user_ban).order(created_at: :desc), items: per_page)
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def ban
    @user = User.find(params[:id])
    @user.user_ban.destroy if @user.user_ban.present?
    @user_ban = UserBan.new user_ban_params
    @user_ban.user = @user

    if @user_ban.save
      head :created
    else
      render(
        'api/v2/base/error',
        locals: { message: 'Vui lòng kiểm tra lại nội dung bạn nhập', data: @user_ban.errors },
        status: :unprocessable_entity
      )
    end
  rescue ActiveRecord::RecordNotFound
    raise NotFoundError, 'Không tìm thấy người dùng mà bạn định ban'
  end

  def unban
    @user = User.find(params[:id])
    @user.user_ban.destroy
  end

  def search
    @keyword = params[:q]
    per_page = if params[:per_page]
                 params[:per_page].to_i.clamp(5, 50)
               else
                 24
               end
    @pagy, @users = pagy(User.all.where('username ILIKE ?', "#{@keyword}%").order(:username), items: per_page)
  end

  private

  def user_ban_params
    params.require(:user_ban).permit(:ban_type, :banned_until, :reason)
  end
end
