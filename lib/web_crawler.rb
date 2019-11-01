# frozen_string_literal: true

require 'colorize'
require 'csv'
require 'fileutils'
require 'http'
require 'singleton'
require 'uri'

require 'web_crawler/concurrent_data_store'
require 'web_crawler/concurrent_set'
require 'web_crawler/file_helpers'
require 'web_crawler/log'
require 'web_crawler/sitemap'
require 'web_crawler/threads_pool'
require 'web_crawler/web'

module WebCrawler

  # TODO: move it to config files
  CONFIG = {
        threads_pool: {
          thread_limit: 40,
          join_timeout: 0.1
        },
        std_out: true,
        use_cache: true
      }
end
