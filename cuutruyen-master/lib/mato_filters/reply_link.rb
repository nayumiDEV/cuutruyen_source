# frozen_string_literal: true

module Mato
  module HtmlFilters
    class ReplyLink
      include Mato::Concerns::HtmlNodeCheckable

      attr_reader :pattern

      REPLY_PATTERN = /(?<!\d)\^[0-9]+\b/ # e.g. ^1234

      def initialize(comment_id, pattern = REPLY_PATTERN)
        @pattern = pattern
        @comment_id = comment_id
      end

      def call(doc)
        doc.xpath('.//text()').each do |text_node|
          next if has_ancestor?(text_node, 'a', 'code', 'pre', 'blockquote')

          content = CGI::escapeHTML(text_node.content)

          mention_html = content.gsub(pattern) do |caret_comment|
            replied_id = caret_comment.gsub(/^\^/, '')

            replied = Comment.includes(:user).find_by(id: replied_id)

            if replied.present?
              %Q[<a href="#" class="reply-comment"><span class="reply-comment-id">#{caret_comment}</span><span class="reply-comment-username">#{replied.user.username}</span></a>]
            else
              %Q[<a href="#" class="reply-comment-not-found">#{caret_comment}</a>]
            end
          end

          text_node.replace(mention_html)
        end
      end
    end
  end
end
