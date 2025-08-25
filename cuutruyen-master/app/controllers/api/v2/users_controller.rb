class Api::V2::UsersController < Api::V2::BaseController
  def create
    @user = User.new user_params
    @user.cuucoin = 0

    if @user.save
      render :create, status: :accepted
    else
      raise UnprocessableEntityError.new('Vui lòng kiểm tra lại nội dung bạn nhập', @user.errors)
    end
  end

  def show
    raise UnauthorizedError, 'Bạn cần đăng nhập để sử dụng tính năng này' unless current_user.present?
    @user = current_user
  end

  def request_reset_password
    raise UnprocessableEntityError, 'Địa chỉ email cần khôi phục mật khẩu không đúng hoặc không tồn tại' unless params[:email].present?
    @user = User.find_by email: params[:email].downcase
    raise UnprocessableEntityError, 'Địa chỉ email cần khôi phục mật khẩu không đúng hoặc không tồn tại' unless @user.present?
    @user.regenerate_reset_password_token
    @user.update_attribute(:reset_password_token_valid_until, 1.week.from_now)
    UserMailer.with(user: @user).reset_password_email.deliver_later

    head :accepted
  end

  def reset_password
    raise UnprocessableEntityError, 'Địa chỉ email cần khôi phục mật khẩu không đúng hoặc không tồn tại' unless params[:email].present?
    @user = User.find_by email: params[:email].downcase
    raise UnprocessableEntityError, 'Địa chỉ email cần khôi phục mật khẩu không đúng hoặc không tồn tại' unless @user.present?
    if @user.reset_password_token != params[:token] || Time.now > @user.reset_password_token_valid_until
      raise UnprocessableEntityError, 'Token khôi phục mật khẩu không đúng hoặc đã hết hạn!'
    end

    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]

    if @user.save
      @user.update reset_password_token: nil, reset_password_token_valid_until: nil
      head :accepted
    else
      render 'api/v2/base/error', locals: { message: 'Vui lòng kiểm tra lại nội dung bạn nhập', data: @user.errors }, status: :unprocessable_entity
    end
  end

  def change_password
    authorize User, :change_password?

    @user = User.find current_user.id
    raise UnprocessableEntityError, 'Mật khẩu cũ mà bạn nhập không chính xác!' unless @user.authenticate(params[:current_password])

    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]

    if @user.save
      current_user.regenerate_auth_token
      head :accepted
    else
      render 'api/v2/base/error', locals: { message: 'Vui lòng kiểm tra lại nội dung bạn nhập', data: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :username,
      :email,
      :password,
      :password_confirmation,
      :captcha_identifer,
      :captcha_phrase,
      :accept
    )
  end
end
