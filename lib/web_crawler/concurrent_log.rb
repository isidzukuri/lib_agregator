# frozen_string_literal: true

module WebCrawler
  class ConcurrentLog
    include Singleton

    attr_accessor :std_out
    attr_reader :store

    def self.puts_system_info(message, color = :cyan)
      instance.puts_system_info(message, color)
    end

    def self.put_in_bucket(key, value)
      instance.put_in_bucket(key, value)
    end

    def self.puts_bucket(key, color = :green)
      instance.puts_bucket(key, color)
    end

    def initialize(config = {})
      @mutex = Mutex.new
      @store = {}
      @std_out = config[:std_out] || true
    end

    def purge
      @store = {}
    end

    def puts_system_info(message, color = :cyan)
      return unless std_out

      puts message.colorize(color)
    end

    def put_in_bucket(key, value)
      mutex.synchronize do
        store[key] = [] unless store[key]
        store[key] << value
      end
    end

    def puts_bucket(key, color = :green)
      return unless std_out

      glue = "\n\s-"
      str = key.to_s + glue + store[key].join(glue)
      puts str.colorize(color)
    end

    private

    attr_reader :mutex
  end
end
