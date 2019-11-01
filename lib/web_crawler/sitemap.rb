# frozen_string_literal: true

require 'web_crawler/sitemap/builder'

module WebCrawler
  module Sitemap
    def self.build(params)
      Builder.new(params).build
    end

    def self.from_file(path)
      set = ConcurrentSet.new
      data = CSV.read(path).flatten
      set.push(data)
      set
    end
  end
end
