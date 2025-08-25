# frozen_string_literal: true

class Team < ApplicationRecord
  include AvatarUploader::Attachment(:avatar)

  has_many :team_members, dependent: :destroy
  has_many :users, through: :team_members
  has_many :translations, dependent: :destroy
  has_many :team_logs, dependent: :destroy
  has_many :mangas, through: :translations
  has_many :chapters, through: :translations
  has_many :notifications, as: :recipient
  has_many :team_posts, dependent: :destroy

  accepts_nested_attributes_for  :team_members, allow_destroy: true

  validates :name, presence: { message: 'Bạn chưa nhập tên nhóm' }, length: { in: 1..90 }
  validates :slug,
    allow_blank: true,
    length: { in: 1..25, message: 'Slug nhóm phải có độ dài từ 1 đến 25 ký tự' },
    uniqueness: { message: 'Slug nhóm đã tồn tại' },
    format: { with: /\A[a-z0-9\-]+\z/, message: 'Slug nhóm chỉ được phép sử dụng ký tự từ a-z (viết thường), số từ 0-9 và dấu gạch ngang' }
  validates :description, length: { in: 1..1000, message: 'Mô tả nhóm phải có độ dài từ 1 đến 1000 ký tự' }, allow_blank: true
  validates :facebook_address, length: { in: 1..90, message: 'Địa chỉ facebook phải có độ dài từ 1 đến 90 ký tự' },
    allow_blank: true,
    format: { with: /\A[A-Za-z0-9\.]+\z/, message: 'Địa chỉ facebook chỉ được phép sử dụng ký tự từ a-z (viết thường) và số từ 0-9 (không viết kèm https://facebook.com/)' }
  validate :team_members_size_at_least_one
  validate :team_members_owner_at_least_one

  before_validation :normalize_attributes

  def normalize_attributes
    self.slug = slug.presence if name.present?
  end

  def team_members_size_at_least_one
    errors.add(:team_members, "Nhóm phải có tối thiểu một thành viên") if team_members.size == 0
  end

  def team_members_owner_at_least_one
    errors.add(:team_members, "Nhóm phải có tối thiểu một thành viên là người quản trị") if team_members.select(&:owner?).size == 0
  end
end
