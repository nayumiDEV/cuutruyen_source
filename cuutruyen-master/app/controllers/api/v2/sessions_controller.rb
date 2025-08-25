class Api::V2::SessionsController < Api::V2::BaseController
  def login
    @user = User.find_by(username: params[:username])
    if @user&.authenticate(params[:password])
      render :login, status: :accepted
    else
      raise UnprocessableEntityError, 'Sai tên đăng nhập hoặc mật khẩu'
    end
  end

  def logout
    raise UnauthorizedError, 'Bạn cần đăng nhập để sử dụng tính năng này' unless current_user.present?

    current_user.regenerate_auth_token
    current_user.update_attribute(:auth_token_valid_until, 1.month.from_now)

    render :logout, status: :accepted
  end

  def geo
    current_geo =
      if Rails.env.development?
        'VN'
      elsif request.headers['HTTP_CF_IPCOUNTRY'].present?
        request.headers['HTTP_CF_IPCOUNTRY']
      else
        'VN'
      end

    render(json: {
      geo: current_geo
    })
  end
end
