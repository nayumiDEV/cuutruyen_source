# frozen_string_literal: true
class ChapterResource < ApplicationResource
  belongs_to :translation
  has_many :pages
  has_many :comments

  attribute :number, :string
  attribute :name, :string
  attribute :order, :integer
  attribute :translation_id, :integer, readable: false, writable: false
  attribute :views_count, :integer, writable: false
  attribute :pages_count, :integer, writable: false
  attribute :comments_count, :integer, writable: false
  attribute :is_drm, :boolean, writable: false do
    drm?(@object)
  end
  attribute :status, :string_enum, writable: false, allow: Chapter.statuses.keys

  extra_attribute :previous_chapter_id, :integer, writable: false
  extra_attribute :previous_chapter_number, :string, writable: false
  extra_attribute :previous_chapter_name, :string, writable: false
  extra_attribute :next_chapter_id, :integer, writable: false
  extra_attribute :next_chapter_number, :string, writable: false
  extra_attribute :next_chapter_name, :string, writable: false

  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
  attribute :edited_at, :datetime, writable: false

  on_extra_attribute :previous_chapter_id do |scope|
    scope.with_cursor
  end

  on_extra_attribute :previous_chapter_number do |scope|
    scope.with_cursor
  end

  on_extra_attribute :previous_chapter_name do |scope|
    scope.with_cursor
  end

  on_extra_attribute :next_chapter_id do |scope|
    scope.with_cursor
  end

  on_extra_attribute :next_chapter_number do |scope|
    scope.with_cursor
  end

  on_extra_attribute :next_chapter_name do |scope|
    scope.with_cursor
  end

  paginate do |scope|
      scope
  end

  filter :manga_id, :integer do
    eq do |scope, value|
      scope.includes(:translation).where(translation: { manga_id: value })
    end
  end

  def delete(model)
    model.discard
    model
  end

  def base_scope
    Pundit.policy_scope(current_user, Chapter.kept)
  end

  def drm?(_model)
    ua = context.request.user_agent
    if ua.include?('CPU OS 12') || ua.include?('CPU iPhone OS 12')
      false
    else
      true
    end
  end
end
