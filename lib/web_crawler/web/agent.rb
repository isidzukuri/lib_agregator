# frozen_string_literal: true

module WebCrawler
  module Web
    class Agent
      # TODO: get rid of Rails dependency
      CACHE = Rails.cache
      STATUS_OK = 200

      def initialize(config = {})
        @config = config
        @config[:use_cache] ||= WebCrawler::CONFIG[:use_cache]
      end

      def get(url)
        if use_cache?
          from_cache(url)
        else
          request(url)
        end
      end

      private

      attr_reader :config

      def use_cache?
        config[:use_cache] == true
      end

      def request(url)
        response = HTTP.get(url)

        if response.status.code == STATUS_OK
          result(response.body.to_s.encode('UTF-8', invalid: :replace, replace: "?"))
        else
          result(nil, [response.status.to_s])
        end
      end

      def from_cache(url)
        cache_key = Digest::SHA1.hexdigest(url)
        data = CACHE.read(cache_key)

        if data
          result(data)
        else
          res = request(url)

          CACHE.write(cache_key, res.page) if res.success?

          res
        end
      end

      def result(page = nil, errors = nil)
        Result.new(page, errors)
      end
    end
  end
end
