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

module WebCrawler
  CONFIG = {
        threads_pool: {
          thread_limit: 20,
          join_timeout: 0.1
        },
        std_out: true,
        use_cache: true
      }
end
