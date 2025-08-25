require "#{Rails.root}/lib/cuucaptcha"
require 'securerandom'

class CaptchaGenerator
  def initialize
    @redis = Redis.new(url: ENV.fetch("REDIS_URL") { "redis://redis:6379/1" })
    @cuucaptcha = Cuucaptcha::Captcha::new
  end

  def generate
    phrase, base64_image = @cuucaptcha.generate
    identifier = SecureRandom.uuid
    @redis.setex "cuucaptcha:#{identifier}", 3600, phrase

    [identifier, base64_image]
  end

  def get_phrase(identifier)
    return nil if identifier.blank?

    phrase = @redis.get "cuucaptcha:#{identifier}"

    return nil if phrase.blank?

    phrase
  end

  def verify(identifier, input_phrase)
    return false if identifier.blank?

    phrase = @redis.get "cuucaptcha:#{identifier}"
    @redis.del "cuucaptcha:#{identifier}"

    return false if phrase.blank?

    # Define Vietnamese sound mappings
    fix_marks = {
      "òa" => "oà", "óa" => "oá", "ỏa" => "oả", "õa" => "oã", "ọa" => "oạ",
      "òe" => "oè", "óe" => "oé", "ỏe" => "oẻ", "õe" => "oẽ", "ọe" => "oẹ",
      "ùy" => "uỳ", "úy" => "uý", "ủy" => "uỷ", "ũy" => "uỹ", "ụy" => "uỵ"
    }

    # Normalize phrase from Redis
    normalized_phrase = normalize_vietnamese_text(phrase, fix_marks)

    # Normalize input phrase
    normalized_input = normalize_vietnamese_text(input_phrase.downcase.strip, fix_marks)

    # Compare normalized versions
    if normalized_phrase != normalized_input
      # Rails.logger.info "Wrong captcha input from user: #{normalized_input}, true answer: #{normalized_phrase}, identifier: #{identifier}"
      return false
    end

    true
  end

  private

  # Helper method to normalize Vietnamese text
  def normalize_vietnamese_text(text, fix_marks)
    return "" if text.blank?

    # First, normalize Unicode to composed form (NFC)
    # This ensures that characters like 'hiếu' are in the same form
    normalized = ActiveSupport::Multibyte::Chars.new(text).unicode_normalize(:nfc).to_s

    # Normalize unnecessary spaces between words
    normalized = normalized.gsub(/\s+/, " ").strip

    # Apply Vietnamese sound mappings
    fix_marks.each do |from, to|
      normalized = normalized.gsub(from, to)
    end

    normalized
  end
end
