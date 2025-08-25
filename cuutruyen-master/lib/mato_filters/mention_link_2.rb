# frozen_string_literal: true

module Mato
  module HtmlFilters
    class MentionLink2
      include Mato::Concerns::HtmlNodeCheckable

      attr_reader :pattern

      MENTION_PATTERN = /\@([a-z0-9]+)\b/ # e.g. @foo

      def initialize(pattern = MENTION_PATTERN)
        @pattern = pattern
      end

      def call(doc)
        doc.xpath('.//text()').each do |text_node|
          next if has_ancestor?(text_node, 'a', 'code', 'pre', 'blockquote')

          content = CGI::escapeHTML(text_node.content)

          reply_html = content.gsub(pattern) do |at_user|
            username = at_user.gsub(/^\@/, '')

            if User.exists?(username: username)
              %Q[<a href="#" class="mention-user">#{at_user}</a>]
            else
              %Q[<a href="#" class="mention-user-not-found">#{at_user}</a>]
            end
          end

          text_node.replace(reply_html)
        end
      end
    end
  end
end
