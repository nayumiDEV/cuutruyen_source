# frozen_string_literal: true
class User < ApplicationRecord
  attr_accessor :accept
  attr_accessor :captcha_identifer
  attr_accessor :captcha_phrase

  has_many :team_members
  has_many :teams, through: :team_members
  has_many :mangas, through: :teams
  has_many :translations, through: :mangas
  has_many :notifications, as: :recipient
  has_many :user_follow_mangas
  has_many :manga_follows, through: :user_follow_mangas, source: :manga
  has_many :web_push_endpoints
  has_many :comments
  has_one :user_ban

  validates :username,
    uniqueness: { case_sensitive: false, message: 'Tên đăng nhập bạn chọn đã tồn tại' },
    format: { with: /\A[a-z0-9]+\z/, message: 'Tên đăng nhập của bạn chỉ được phép sử dụng ký tự từ a-z (viết thường) và số từ 0-9' },
    presence: { message: 'Bạn chưa nhập tên đăng nhập' },
    length: { in: 4..20, message: 'Tên đăng nhập phải dài từ 4-20 ký tự' }
  validates :email,
    uniqueness: { case_sensitive: false, message: 'Email bạn chọn đã tồn tại' },
    format: { with: /@/, message: 'Email bạn nhập không hợp lệ' },
    presence: { message: 'Bạn chưa nhập email' },
    length: { in: 5..50, message: 'Email phải dài từ 5-50 ký tự' }
  validates :password,
    confirmation: { message: 'Mật khẩu nhập lại không khớp với mật khẩu ban đầu' },
    presence: { message: 'Bạn chưa nhập mật khẩu' },
    length: { in: 6..30, message: 'Mật khẩu bạn chọn phải dài từ 6-30 ký tự' },
    on: :create
  validates :password,
    confirmation: { message: 'Mật khẩu nhập lại không khớp với mật khẩu ban đầu' },
    presence: { message: 'Bạn chưa nhập mật khẩu' },
    length: { in: 6..30, message: 'Mật khẩu bạn chọn phải dài từ 6-30 ký tự' },
    on: :update,
    if: :password_digest_changed?
  validates :password_confirmation,
    presence: { message: 'Bạn chưa nhập lại mật khẩu' },
    on: :create
  validates :password_confirmation,
    presence: { message: 'Bạn chưa nhập lại mật khẩu' },
    on: :update,
    if: :password_digest_changed?
  validate :accept_must_be_true, on: :create
  validate :captcha_phrase_must_be_valid, on: :create

  before_save { email.downcase! }

  enum level: { user: 0, admin: 3 }

  has_secure_token :auth_token
  has_secure_token :reset_password_token
  has_secure_password validations: false

  def accept_must_be_true
    unless accept
      errors.add(:accept, 'Bạn cần phải chấp nhận điều khoản sử dụng và chính sách bảo mật để đăng ký Cứu Truyện')
    end
  end

  def captcha_phrase_must_be_valid
    captcha_identifier = captcha_identifer # FIXME, fix typo
    captcha_generator = CaptchaGenerator.new

    true_phrase = captcha_generator.get_phrase(captcha_identifier)

    unless captcha_generator.verify(captcha_identifier, captcha_phrase)
      errors.add(:captcha_phrase, 'Mã captcha bạn nhập không hợp lệ')
    end
  end

  # Returns a masked version of the user's email for privacy
  def masked_email
    return '' unless email.present?
    local, domain = email.split('@')
    return email unless domain
    domain_name, *domain_parts = domain.split('.')
    domain_ext = domain_parts.join('.')
    masked_local = local[0, 3] + '***'
    masked_domain = domain_name[0, 2] + '***'
    masked = "#{masked_local}@#{masked_domain}.#{domain_ext}"
    masked
  end
end
