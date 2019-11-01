# frozen_string_literal: true

module WebCrawler
  module Web
    class Result < Struct.new(:page, :errors)
      def success?
        errors.nil?
      end
    end
  end
end
