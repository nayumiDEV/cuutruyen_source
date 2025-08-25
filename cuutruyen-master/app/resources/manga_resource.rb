# frozen_string_literal: true

class MangaResource < ApplicationResource
  belongs_to :author
  has_many :translations
  has_many :titles
  has_one :newest_chapter, resource: ChapterResource
  many_to_many :categories
  many_to_many :teams

  attribute :name, :string, writable: false do
    @object.primary_title&.name
  end
  attribute :description, :string
  attribute :official_url, :string
  attribute :cover, :string, readable: false
  attribute :cover_url, :string, readable: :cover_ready?, writable: false do
    @object.cover(:processed)&.url
  end
  attribute :cover_mobile_url, :string, readable: :cover_mobile_ready?, writable: false do
    @object.cover(:processed_mobile)&.url
  end
  attribute :cover_original_url, :string, writable: false do
    @object.cover&.url
  end
  attribute :panorama, :string, readable: false
  attribute :panorama_url, :string, readable: :panorama_ready?, writable: false do
    @object.panorama(:processed)&.url
  end
  attribute :panorama_mobile_url, :string, readable: :panorama_mobile_ready?, writable: false do
    @object.panorama(:processed_mobile)&.url
  end
  attribute :panorama_original_url, :string, writable: false do
    @object.panorama&.url
  end
  attribute :focus_x, :integer
  attribute :focus_y, :integer
  attribute :cover_dominant_color, :string, readable: :cover_ready?, writable: false do
    if @object&.cover(:processed)&.dominant_color
      @object&.cover(:processed)&.dominant_color
    else
      "#444447"
    end
  end
  attribute :panorama_dominant_color, :string, readable: :cover_ready?, writable: false do
    if @object&.panorama(:processed)&.metadata && @object.panorama(:processed).metadata["dominant_color"]
      @object&.panorama(:processed)&.metadata["dominant_color"]
    else
      "#444447"
    end
  end
  attribute :panorama_dominant_color_2, :string, readable: :cover_ready?, writable: false do
    if @object&.panorama(:processed)&.metadata && @object.panorama(:processed).metadata["dominant_color_2"]
      @object&.panorama(:processed)&.metadata["dominant_color_2"]
    else
      "#444447"
    end
  end
  attribute :is_ready, :boolean, writable: false do
    @object.panorama(:processed).present? &&
      @object.cover(:processed).present?
  end
  extra_attribute :is_following, :boolean, writable: false do
    @object.user_follows.where(id: current_user.id).any? if current_user.present?
  end
  attribute :status, :string_enum, writable: false, allow: Manga.statuses.keys
  attribute :newest_chapter_number, :string, writable: false do
    @object.newest_chapter&.number
  end
  attribute :newest_chapter_id, :string, writable: false do
    @object.newest_chapter&.id
  end
  attribute :newest_chapter_created_at, :datetime, writable: false do
    @object.newest_chapter&.created_at
  end
  attribute :marginless, :boolean
  attribute :direction, :string
  attribute :views_count, :integer, writable: false
  attribute :views_count_week, :integer, writable: false
  attribute :views_count_month, :integer, writable: false
  attribute :is_region_limited, :boolean
  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false

  stat chapters: [:count]

  filter :has_chapter, :boolean do
    eq do |scope, value|
      if value
        scope.where('newest_chapter_id IS NOT NULL')
      else
        scope.where('newest_chapter_id IS NULL')
      end
    end
  end

  filter :follow, :boolean do
    eq do |scope, value|
      if value
        scope.where(id: UserFollowManga.where(user_id: current_user).pluck(:manga_id))
      end
    end
  end

  sort :newest_chapter_created_at, :string do |scope, direction|
    if direction == :desc
      scope.select("newest_chapter.created_at").order('newest_chapter.created_at': :desc)
    elsif direction == :asc
      scope.select("newest_chapter.created_at").order('newest_chapter.created_at': :asc)
    end
  end

  def delete(model)
    model.discard
    model
  end

  def cover_ready?(model)
    model.cover(:processed).present?
  end

  def panorama_ready?(model)
    model.panorama(:processed).present?
  end

  def cover_mobile_ready?(model)
    model.cover(:processed_mobile).present?
  end

  def panorama_mobile_ready?(model)
    model.panorama(:processed_mobile).present?
  end

  def resolve(scope)
    scope.to_a
  end

  def base_scope
    Pundit.policy_scope(current_user, Manga.kept.joins_newest_chapter.joins_primary_title.select("mangas.*"))
  end
end
