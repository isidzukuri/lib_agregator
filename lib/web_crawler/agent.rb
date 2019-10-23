# frozen_string_literal: true

module WebCrawler
  class Agent

    STATUS_OK = 200

    # CACHE = Rails.cache

    Result = Struct.new(:page, :errors) do
      def success?
        errors.nil?
      end
    end

    def get(url)
      # if cache
      response = HTTP.get(url)

      process_response(response)
    end

    private

    def process_response(response)
      if response.status.code == STATUS_OK
        Result.new(response.body.to_s)
      else
        Result.new(nil, [response.status.to_s])
      end
    end

  end
end
