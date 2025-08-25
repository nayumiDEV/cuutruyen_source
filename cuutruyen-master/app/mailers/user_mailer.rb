class UserMailer < ApplicationMailer
  def reset_password_email
    @user = params[:user]
    @reset_password_url = "#{ENV['BASE_URL']}/reset-password?email=#{@user.email}&token=#{@user.reset_password_token}"
    mail to: @user.email, subject: 'Khôi phục lại mật khẩu tài khoản Cứu Truyện của bạn'
  end
end
