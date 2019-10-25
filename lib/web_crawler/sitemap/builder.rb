module WebCrawler
  module Sitemap
    class Builder

      attr_reader :queue, :sitemap_items, :threads_pool

        @sitemap_items = ConcurrentSet.new
        @queue = ProcessableQueue.new(processor)
        # @threads_pool = ThreadsPool.new(thread_limit: config[:thread_limit])
      end


      # start with one thread
      #   add urls to queue
      #   if queue size > max_thread_number
      #     start new thread
      #

      def build(params)
        queue.push(params[:entry_point])

        queue.process
      end

      # private

      def processor
        Proc.new {|url| find_links(url) }
      end

      def find_links(url)
        agent = Agent.new
        html = agent.get(url)

        # parse html
        # store data
        # queue_push(new_urls)
      end


      # def build
      #   get_start_page
      #   find_links
      #   save urls
      #   if usefull hrefs
      #     add hrefs to processing_queue
      #     run threads
      #
      #   save to file
      #   return sitemap
      # end
      #
      # def find_links(params)
      #   {
      #     website: url,
      #     look_for_href_pattern: [regex || nil], # if nil gothru all
      #     save_href_pattern: regex || nil, # if nil all are saved
      #   }
      # end
      #
      # def run_threads
      #   spawn thread
      #     thread while processing_queue not empty
            # Agent.new
            # agent.get urls_queue.next
      #       save urls
      #       add hrefs to processing_queue
      #    join thread
      # end

    end
  end
end
