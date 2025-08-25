# frozen_string_literal: true

class Chapter < ApplicationRecord
  include Discard::Model

  belongs_to :translation, touch: true
  has_many :pages, dependent: :destroy
  has_many :comments, as: :commentable, class_name: 'Comment', dependent: :destroy

  accepts_nested_attributes_for :pages

  counter_culture :translation

  validates :name, presence: true, allow_blank: true
  validates :number, presence: true

  enum status: { enqueued: 0, processing: 1, processed: 2, failed: 3 }, _default: :enqueued

  scope :newest, -> { order(created_at: :desc).limit(1) }

  after_create_commit do
    manga = translation.manga
    notification = NewChapterNotification.with(
      chapter_id: self.id,
      chapter_number: self.number,
      chapter_name: self.name,
      manga_id: manga.id,
      manga_title: manga.primary_title.name,
      manga_cover_url: manga.cover(:processed)&.url,
      manga_panorama_url: manga.panorama(:processed)&.url
    )
    following_users = manga.user_follows
    notification.deliver_later(following_users)

    update_status
    update_manga_newest_chapter
    recalculate_manga_trending_score
  end

  after_update_commit do
    if (previous_changes.keys & [:number, :name, :order, :discarded_at]).present?
      update_column :edited_at, Time.now
    end

    if previous_changes.keys.include? :order
      update_manga_newest_chapter
    end

    if translation.manga.newest_chapter_id == self.id && previous_changes.keys.include?(:views_count)
      recalculate_manga_trending_score
    end

    if previous_changes.has_key?('status') || previous_changes.has_key?('progress')
      ActionCable.server.broadcast("chapter_processing_status_channel_#{self.id}", { status: self.status, progress: self.progress })
    end
  end

  before_destroy do
    manga = translation.manga
    manga.update_column :newest_chapter_id, nil
  end

  after_destroy_commit do
    update_manga_newest_chapter
    recalculate_manga_trending_score
  end

  after_discard do
    update_manga_newest_chapter
    recalculate_manga_trending_score
  end

  scope :with_previous_chapter, -> do
    select('previous_chapter.id as previous_chapter_id, previous_chapter.number as previous_chapter_number, previous_chapter.name as previous_chapter_name')
      .joins('LEFT JOIN chapters previous_chapter ON previous_chapter.id = (SELECT c.id FROM chapters c WHERE chapters.translation_id = c.translation_id AND c.order < chapters.order AND discarded_at IS NULL ORDER BY c.order DESC LIMIT 1)')
  end

  scope :with_next_chapter, -> do
    select('next_chapter.id as next_chapter_id, next_chapter.number as next_chapter_number, next_chapter.name as next_chapter_name')
      .joins('LEFT JOIN chapters next_chapter ON next_chapter.id = (SELECT c.id FROM chapters c WHERE chapters.translation_id = c.translation_id AND c.order > chapters.order AND discarded_at IS NULL ORDER BY c.order LIMIT 1)')
  end

  scope :with_cursor, -> do
    select('chapters.*')
      .with_previous_chapter
      .with_next_chapter
  end

  def update_manga_newest_chapter
    translation.manga.update_newest_chapter
  end

  def recalculate_manga_trending_score
    translation.manga.recalculate_trending_score
  end

  def update_status
    return if self.destroyed?

    statuses = pages.pluck(:status).map(&:to_sym)

    if statuses.all? :processed
      update_column :status, :processed
      update_column :progress, 1.0
    elsif statuses.any? :failed
      update_column :status, :failed
      update_column :progress, 0.0
    elsif statuses.any?(:processing) || statuses.any?(:processed)
      total = statuses.count
      processed = statuses.select{ |item| item === :processed }.count
      update_column :status, :processing
      update_column :progress, processed.to_f / total
    else
      update_column :status, :enqueued
      update_column :progress, 0.0
    end
  end

  def update_status!
    statuses = pages.pluck(:status).map(&:to_sym)

    if statuses.all? :processed
      update! status: :processed, progress: 1.0
    elsif statuses.any? :failed
      update! status: :failed
    elsif statuses.any?(:processing) || statuses.any?(:processed)
      total = statuses.count
      processed = statuses.select { |item| item == :processed }.count
      update! status: :processing, progress: processed.to_f / total
    else
      update! status: :enqueued, progress: 0.0
    end
  end
end
