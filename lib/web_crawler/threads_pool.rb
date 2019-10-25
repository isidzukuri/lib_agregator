# frozen_string_literal: true

module WebCrawler
  class ThreadsPool
    attr_reader :pool, :thread_limit

    THREAD_LIMIT = 5

    def initialize(config = {})
      @pool = ConcurrentSet.new
      @thread_limit = config[:thread_limit] || THREAD_LIMIT
    end

    def limit_reached?
      thread_limit <= alive_count
    end

    def alive_count
      threads.count(&:alive?)
    end

    def start_thread(&process)
      return :limit_reached if limit_reached?

      thr = Thread.new { process&.call }

      pool.push(thr)

      :ok
    end

    def threads
      pool.store
    end

    def join
      threads.each(&:join)
    end
  end
end

# threads = []
# def start_thread(&process)
#   thr = Thread.new {process.call}
#   # threads << thr
# end
#
# def s
#   p 1
# end
#
# start_thread {s}
#
#
#
# def t(&b)
#    b.call
# end
#
# def t
# threads = []
# threads << Thread.new { while true do; p 1; sleep(5);end}
# threads << Thread.new { while true do; p 2; sleep(5);end}
# threads.each(&:join)
# end
#
# def t
# t1 = Thread.new { while true do; p 1; sleep(5);end}
# t1.join
# t2 = Thread.new { while true do; p 2; sleep(5);end}
# t2.join
# end
