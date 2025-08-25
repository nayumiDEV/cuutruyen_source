# frozen_string_literal: true

module Mato
  module HtmlFilters
    class TransformImg
      def call(doc)
        doc.css('img').each do |img_node|
          src = img_node['src']
          alt = img_node['alt']

          if alt.present?
            img_node.replace(%Q[<a class="linkified-img" href="#{src}" target="_blank" rel="noopener noreferrer">ảnh (#{alt})</a>])
          else
            img_node.replace(%Q[<a class="linkified-img" href="#{src}" target="_blank" rel="noopener noreferrer">ảnh</a>])
          end
        end
      end
    end
  end
end
