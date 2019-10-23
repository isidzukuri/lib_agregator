# frozen_string_literal: true

module WebCrawler
  class ConcurrentSet
    attr_reader :store, :current_position

    def initialize
      @current_position = 0
      @lock = Mutex.new
      @store = []
    end

    def next
      lock.synchronize do
        value = store[current_position]
        increment_current_position if value
        value
      end
    end

    def push(data)
      data = [data] unless data.is_a?(Array)

      data.each do |item|
        next if item.nil? || store.include?(item)

        store << item
      end
    end

    private

    attr_reader :lock

    def increment_current_position
      @current_position += 1
    end
  end
end
