module Cuucaptcha
  class Captcha
    def initialize
    end

    def generate
      output, status = Open3.capture2e('/api/lib/scripts/cuucaptcha')

      unless status.success?
        raise StandardError, output
      end

      phrase, image_base64 = output.split("|")
      return phrase, image_base64
    end
  end
end
