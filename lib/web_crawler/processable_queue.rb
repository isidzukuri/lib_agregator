# frozen_string_literal: true

module WebCrawler
  class ProcessableQueue
    SUPERVISE_PERIOD = 1

    attr_reader :queue, :threads_pool, :processor

    def initialize(processor, config = {})
      @processor = processor
      @queue = ConcurrentSet.new
      @threads_pool = ThreadsPool.new(thread_limit: config[:thread_limit])
    end

    def process
      start_supervisor

      threads_pool.join
    end

    def push(items)
      queue.push(items)
    end

    private

    def start_supervisor
      threads_pool.start_thread { supervisor }
    end

    def start_workers
      queue.next_remain.times do
        res = threads_pool.start_thread { worker(processor) }

        break if res[:status] == :limit_reached
      end
    end

    def supervisor
      while queue.next_remain > 0
        start_workers
        sleep(SUPERVISE_PERIOD)
      end
    end

    def worker(processor)
      while (item = queue.next)

        processor.call(item)
      end
    end
  end
end
