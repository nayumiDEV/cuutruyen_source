require 'mato'
require "#{Rails.root}/lib/mato_filters/reply_link.rb"
require "#{Rails.root}/lib/mato_filters/mention_link_2.rb"
require "#{Rails.root}/lib/mato_filters/sanitization_2.rb"
require "#{Rails.root}/lib/mato_filters/transform_a.rb"
require "#{Rails.root}/lib/mato_filters/transform_img.rb"

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :page, optional: true
  belongs_to :chapter, touch: true, optional: true
  belongs_to :translation
  belongs_to :commentable, polymorphic: true
  has_many :comment_replieds, foreign_key: :replied_id, class_name: "CommentReply"
  has_many :replieds, through: :comment_replieds, source: :replied, dependent: :destroy
  has_many :comment_replies, foreign_key: :reply_id, class_name: "CommentReply"
  has_many :replies, through: :comment_replies, source: :reply, dependent: :destroy
  belongs_to :remover, class_name: 'User', optional: true

  counter_culture :commentable,
                 column_names: {
                   ["comments.commentable_type = ? AND comments.commentable_id IS NOT NULL", "Chapter"] => "comments_count"
                 }

  validates :content,
    presence: true,
    length: { in: 1..1000 }

  before_save do
    @doc = process_content
    html = @doc.render_html
    self.processed_content = html
  end

  # Helper method to ensure backward compatibility
  def chapter
    commentable if commentable.is_a?(Chapter)
  end

  after_create_commit do
    # @doc = process_content
    # self.update_column :processed_content, @doc.render_html

    notice_to_team
    notice_mention
    notice_reply
    save_reply_refs
    recalculate_manga_trending_score
  end

  before_destroy prepend: true do
    @reply_comments = CommentReply.select(:reply_id).where(replied_id: id).pluck(:reply_id)
  end

  after_destroy_commit do
    if @reply_comments.present?
      Comment.where(id: @reply_comments).each do |comment|
        comment.update_processed_content
      end
    end
  end

  def process_content
    mato = Mato.define do |config|
      config.append_html_filter(Mato::HtmlFilters::TransformA.new)
      config.append_html_filter(Mato::HtmlFilters::TransformImg.new)
      config.append_html_filter(Mato::HtmlFilters::ReplyLink.new(self.id))
      config.append_html_filter(Mato::HtmlFilters::MentionLink2.new)
      config.append_html_filter(Mato::HtmlFilters::Sanitization2.new)
    end

    mato.process(content)
  end

  def update_processed_content
    @doc = process_content
    self.update_column :processed_content, @doc.render_html
  end

  def notice_to_team
    return unless commentable.is_a?(Chapter)

    manga = translation.manga
    notification = NewCommentNotification.with(
      chapter_id: commentable.id,
      chapter_number: commentable.number,
      manga_id: manga.id,
      manga_title: manga.primary_title.name,
      manga_cover_url: manga.cover(:processed)&.url,
      truncated_content: content.truncate_words(12).truncate(60).strip,
      comment_id: self.id,
      comment_username: self.user.username
    )

    notification.deliver_later(translation.team)
  end

  def notice_mention
    unless @doc
      @doc = process_content
    end

    usernames = @doc.css('.mention-user').map do |node|
      next unless node.child
      at_username = node.child.content
      at_username.gsub(/^\@/, '')
    end

    return if usernames.empty?

    if commentable.is_a?(Chapter)
      manga = translation.manga

      notification = MentionNotification.with(
        chapter_id: commentable.id,
        chapter_number: commentable.number,
        manga_id: manga.id,
        manga_title: manga.primary_title.name,
        manga_cover_url: manga.cover(:processed)&.url,
        truncated_content: content.truncate_words(12).truncate(60).strip,
        comment_id: self.id,
        comment_username: self.user.username
      )
    elsif commentable.is_a?(TeamPost)
      notification = MentionNotification.with(
        team_post_id: commentable.id,
        team_id: commentable.team_id,
        team_name: commentable.team.name,
        truncated_content: content.truncate_words(12).truncate(60).strip,
        comment_id: self.id,
        comment_username: self.user.username
      )
    else
      return
    end

    notice_users = User.where(username: usernames)
    notification.deliver_later(notice_users)
  end

  def save_reply_refs
    unless @doc
      @doc = process_content
    end

    comment_ids = @doc.css('.reply-comment-id').map do |node|
      next unless node.child
      caret_comment_id = node.child.content
      caret_comment_id.gsub(/^\^/, '')
    end

    comment_ids.each do |replied_id|
      CommentReply.upsert({ replied_id: replied_id, reply_id: self.id }, unique_by: [:replied_id, :reply_id])
    end
  end

  def notice_reply
    unless @doc
      @doc = process_content
    end

    comment_ids = @doc.css('.reply-comment').map do |node|
      next unless node.child
      caret_comment_id = node.child.content
      caret_comment_id.gsub(/^\^/, '')
    end

    return if comment_ids.empty?

    if commentable.is_a?(Chapter)
      manga = translation.manga

      notification = ReplyNotification.with(
        chapter_id: commentable.id,
        chapter_number: commentable.number,
        manga_id: manga.id,
        manga_title: manga.primary_title.name,
        manga_cover_url: manga.cover(:processed)&.url,
        truncated_content: content.truncate_words(12).truncate(60).strip,
        comment_id: self.id,
        comment_username: self.user.username
      )
    elsif commentable.is_a?(TeamPost)
      notification = ReplyNotification.with(
        team_post_id: commentable.id,
        team_id: commentable.team_id,
        team_name: commentable.team.name,
        truncated_content: content.truncate_words(12).truncate(60).strip,
        comment_id: self.id,
        comment_username: self.user.username
      )
    else
      return
    end

    user_ids = Comment.where(id: comment_ids).pluck(:user_id)
    notice_users = User.where(id: user_ids)

    notification.deliver_later(notice_users)
  end

  def recalculate_manga_trending_score
    return unless commentable.is_a?(Chapter)
    translation.manga.recalculate_trending_score
  end
end
