# frozen_string_literal: true

module WebCrawler
  class ConcurrentSet
    attr_reader :store, :current_position

    def initialize
      @current_position = 0
      @mutex = Mutex.new
      @store = []
    end

    def next
      mutex.synchronize do
        value = store[current_position]
        increment_current_position if value
        value
      end
    end

    def next_remain
      mutex.synchronize do
        size - current_position
      end
    end

    def push(data)
      data = [data] unless data.is_a?(Array)

      mutex.synchronize do
        data.each do |item|
          next if item.nil? || store.include?(item)

          store << item
        end
      end
    end

    def size
      store.size
    end

    private

    attr_reader :mutex

    def increment_current_position
      @current_position += 1
    end
  end
end
