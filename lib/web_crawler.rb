# frozen_string_literal: true

# require 'nokogiri'
require 'uri'
require 'http'
require 'csv'
require 'fileutils'
require 'colorize'
require 'singleton'

require 'web_crawler/agent'
require 'web_crawler/concurrent_set'
require 'web_crawler/threads_pool'
require 'web_crawler/sitemap'
require 'web_crawler/file_helpers'
require 'web_crawler/concurrent_log'


# data store (with sync thread)
# web_agent
# sitemap
# sitemap_builder

module WebCrawler
  # def parse(params)
  #   params = {
  #     sitemap : {
  #       website: url,
  #       look_for_href_pattern: [regex || nil], # if nil gothru all
  #       save_href_pattern: regex || nil, # if nil all are saved
  #     },
  #     data_extractor : {
  #       class: SomeClassName
  #     },
  #     thread_limit: 10,
  #     cache: true,
  #     working_dir: date || generate from url name
  #   }
  #
  #   config = build_config(params)
  #   sitemap = build_sitemap
  #   parse(sitemap)
  # end
end
