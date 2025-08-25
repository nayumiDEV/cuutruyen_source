# frozen_string_literal: true
class PageResource < ApplicationResource
  belongs_to :chapter
  has_many :comments

  attribute :order, :integer
  attribute :image, :string, readable: false
  attribute :image_url, :string, readable: :image_ready?, writable: false do
    @object.image(:scrambled)&.url
  end
  attribute :image_normal_url, :string, readable: :image_normal_readable?, writable: false do
    @object.image(:normal)&.url
  end
  attribute :image_original_url, :string, readable: :sensitive_readable?, writable: false do
    @object.image&.url
  end
  attribute :image_filename, :string, readable: :sensitive_readable?, writable: false do
    @object.image["filename"]
  end
  attribute :width, :integer, writable: false do
    @object.image(:normal)&.width
  end
  attribute :height, :integer, writable: false do
    @object.image(:normal)&.height
  end
  attribute :is_ready, :boolean, writable: false do
    @object.image(:scrambled).present?
  end
  attribute :is_drm, :boolean, writable: false do
    drm?(@object)
  end
  attribute :drm_data, :string, readable: :image_ready?, writable: false
  attribute :marginless, :boolean, writable: false do
    @object.chapter.translation.manga.marginless
  end
  attribute :status, :string_enum, writable: false, allow: Page.statuses.keys
  attribute :chapter_id, :integer, readable: false, writable: false
  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false

  paginate do |scope|
      scope
  end

  def image_ready?(model)
    model.image(:scrambled).present?
  end

  def sensitive_readable?(model)
    Pundit.policy(current_user, model).public_send(:show_sensitive?)
  end

  def drm?(_model)
    ua = context.request.user_agent
    if ua.include?('CPU OS 12') || ua.include?('CPU iPhone OS 12')
      false
    else
      true
    end
  end

  def image_normal_readable?(model)
    if !drm?(model) || sensitive_readable?(model)
      true
    else
      false
    end
  end

  def base_scope
    Pundit.policy_scope(current_user, Page.includes(chapter: { translation: :manga }))
  end
end
