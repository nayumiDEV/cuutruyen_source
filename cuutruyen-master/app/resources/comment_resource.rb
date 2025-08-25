# frozen_string_literal: true
class CommentResource < ApplicationResource
  belongs_to :page
  belongs_to :chapter
  belongs_to :translation
  belongs_to :user
  many_to_many :replieds, resource: CommentResource, foreign_key: { comment_replies: :replied_id }
  many_to_many :replies, resource: CommentResource, foreign_key: { comment_replies: :reply_id }

  attribute :content, :string
  attribute :processed_content, :string, writable: false
  attribute :page_id, :integer, readable: false, writable: false
  attribute :chapter_id, :integer, readable: false, writable: false
  attribute :translation_id, :integer, readable: false, writable: false
  attribute :user_id, :integer, readable: false, writable: false
  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false

  def base_scope
    Pundit.policy_scope(current_user, Comment)
  end

  paginate do |scope|
      scope
  end
end
