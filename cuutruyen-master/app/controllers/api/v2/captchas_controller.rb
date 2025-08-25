class Api::V2::CaptchasController < Api::V2::BaseController
  def generate
    captcha_generator = CaptchaGenerator.new
    @identifer, @base64_image = captcha_generator.generate
  end
end
