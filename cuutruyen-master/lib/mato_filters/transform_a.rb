# frozen_string_literal: true

module Mato
  module HtmlFilters
    class TransformA
      def call(doc)
        doc.css('a').each do |a_node|
          a_node['target'] = '_blank'
          a_node['rel'] = 'noopener noreferrer'
        end
      end
    end
  end
end
