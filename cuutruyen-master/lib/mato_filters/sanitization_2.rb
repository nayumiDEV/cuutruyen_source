require 'sanitize'

module Mato
  module HtmlFilters
    class Sanitization2
      attr_reader :sanitize

      # @param [Sanitize] sanitize
      def initialize(sanitize = Sanitize)
        @sanitize = sanitize
      end

      def call(doc)
        sanitize.node!(doc, Sanitize::Config::RELAXED)
      end
    end
  end
end
