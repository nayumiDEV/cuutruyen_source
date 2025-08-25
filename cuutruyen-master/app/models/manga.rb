# frozen_string_literal: true

class Manga < ApplicationRecord
  include CoverUploader::Attachment(:cover)
  include PanoramaUploader::Attachment(:panorama)
  include Discard::Model
  include MeiliSearch::Rails
  extend Pagy::Meilisearch
  ActiveRecord_Relation.include Pagy::Meilisearch

  belongs_to :author
  has_many :category_mangas, dependent: :destroy
  has_many :categories, through: :category_mangas
  has_many :translations, dependent: :destroy
  has_one :translation
  has_many :chapters, through: :translations
  has_many :pages, through: :chapters
  has_many :teams, through: :translations
  has_one :team, through: :translation
  has_many :titles, dependent: :destroy
  belongs_to :newest_chapter, class_name: 'Chapter', foreign_key: 'newest_chapter_id', required: false
  belongs_to :primary_title, class_name: 'Title', foreign_key: 'primary_title_id', required: false
  has_many :user_follow_mangas, dependent: :destroy
  has_many :user_follows, through: :user_follow_mangas, source: :user
  has_many :manga_logs, dependent: :destroy

  has_many :manga_tags, dependent: :destroy
  has_many :tags, through: :manga_tags

  accepts_nested_attributes_for :author, update_only: true
  accepts_nested_attributes_for :titles, allow_destroy: true

  validates :cover, presence: true
  validates :panorama, presence: true
  validates :full_description, length: { in: 0..10000, message: 'Mô tả phải có độ dài từ 0 đến 10000 ký tự' }, allow_blank: true
  validates :description, length: { in: 0..170, message: 'Mô tả ngắn phải có độ dài từ 0 đến 170 ký tự' }, allow_blank: true
  validates :official_url, url: { allow_blank: true }

  enum status: { enqueued: 0, processing: 1, processed: 2, failed: 3 }, _default: :enqueued
  enum direction: { rtl: 0, ltr: 1 }, _default: :rtl

  scope :has_chapter, ->(is_true) {
    if is_true
      where('newest_chapter_id IS NOT NULL')
    else
      where('newest_chapter_id IS NULL')
    end
  }

  scope :joins_newest_chapter, ->() {
    joins("LEFT JOIN chapters as newest_chapter ON newest_chapter.id = mangas.newest_chapter_id")
  }

  scope :joins_primary_title, ->() {
    joins("LEFT JOIN titles as primary_title ON primary_title.id = mangas.primary_title_id")
  }

  before_validation do
    full_description = Sanitize.fragment(full_description, Sanitize::Config::RELAXED)
  end

  after_save :save_tags

  after_create_commit do
    recalculate_trending_score
  end

  def update_newest_chapter
    unless self.destroyed?
      update_column :newest_chapter_id, chapters.kept.order(created_at: :desc).first&.id
    end
  end

  def recalculate_trending_score
    unless self.destroyed?
      score = TrendingCalculator.new.calculate self
      update_column :trending_score, score
    end
  end

  def panorama_dominant_color
    if panorama(:processed)&.metadata && panorama(:processed).metadata["dominant_color"]
      panorama(:processed)&.metadata["dominant_color"]
    else
      "#444447"
    end
  end

  def panorama_dominant_color_2
    if panorama(:processed)&.metadata && panorama(:processed).metadata["dominant_color_2"]
      panorama(:processed)&.metadata["dominant_color_2"]
    else
      "#444447"
    end
  end

  meilisearch do
    attribute :name do
      primary_title&.name
    end
    attribute :titles do
      titles.where(primary: false).map(&:name).join(", ")
    end
    attribute :author do
      author.name
    end
    attribute :description
    attribute :team_id do
      translations.first&.team&.id
    end
    attribute :is_discarded do
      discarded?
    end
    filterable_attributes [:team_id, :is_discarded]
    sortable_attributes [:views_count]
    ranking_rules [
      "words",
      "exactness",
      "proximity",
      "attribute",
      "sort",
      "typo"
    ]
  end

  def short_description
    if description.present?
      description
    else
      Sanitize.fragment(full_description).strip.truncate_words(40)
    end
  end

  def full_description_2
    if full_description.present?
      full_description
    elsif description.present?
      Sanitize.fragment(description)
    else
      nil
    end
  end

  def tags_list
    @tags_list_array = tags.map(&:name) if @tags_list_array.blank?
    @tags_list_array
  end

  def tags_list= value
    @tags_list_array = value
      .map{ |name| name.strip.downcase }
      .reject{ |name| name.blank? && name.parameterize.blank? }
  end

  def save_tags
    return unless @tags_list_array && @tags_list_array.size > 0

    manga_tags.destroy_all

    @tags_list_array.each do |tag_name|
      tag = Tag.where(name: tag_name, slug: tag_name.to_url).first_or_create
      manga_tags.create tag: tag
    end
  end

  def is_nsfw
    tags_list.include? 'nsfw'
  end
end
