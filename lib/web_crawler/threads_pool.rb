# frozen_string_literal: true

module WebCrawler
  class ThreadsPool
    attr_reader :pool, :thread_limit, :join_timeout

    THREAD_LIMIT = 5
    JOIN_TIMEOUT = 0.1

    def initialize(config = {})
      @pool = ConcurrentSet.new
      @thread_limit = config[:thread_limit] || THREAD_LIMIT
      @join_timeout = config[:join_timeout] || JOIN_TIMEOUT
    end

    def limit_reached?
      thread_limit <= alive_count
    end

    def alive_count
      threads.count(&:alive?)
    end

    def start_thread(&process)
      return { status: :limit_reached } if limit_reached?

      thr = Thread.new { process&.call }

      pool.push(thr)

      { status: :ok, thread: thr }
    end

    def threads
      pool.store
    end

    def join
      sleep(join_timeout) while alive_count > 0
      threads.each(&:join)
    end
  end
end
