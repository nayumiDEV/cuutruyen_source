class TeamPost < ApplicationRecord
  belongs_to :team
  has_many :comments, as: :commentable, dependent: :destroy

  validates :content, length: { in: 2..100000, message: 'Nội dung quá ngắn hoặc quá dài (tối đa là 10000 ký tự)' }

  before_validation do
    content = Sanitize.fragment(content, Sanitize::Config::RELAXED)
  end
end
