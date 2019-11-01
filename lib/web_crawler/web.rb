# frozen_string_literal: true

require 'web_crawler/web/agent'
require 'web_crawler/web/result'

module WebCrawler
  module Web
    def self.site_info(url)
      uri = URI(url)

      raise(InvalidUrlError, "'url' does not contain host") unless uri.host

      { host: uri.host, scheme: uri.scheme }
    end

    def self.load_page(url)
      agent = Web::Agent.new
      res = agent.get(url)

      if res.success?
        Log.puts_success(url)
      else
        message = "#{url}: #{res.errors}"
        Log.puts_alert(message)
      end

      res.page
    end
  end
end
