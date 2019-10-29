# frozen_string_literal: true

module WebCrawler
  class Parser
    attr_reader :queue, :data, :data_store, :data_miner, :site

    def initialize(sitemap, data_miner)
      @data_miner = data_miner
      @data = ConcurrentSet.new
      @queue = ProcessableQueue.new(processor, sitemap)
      @site = Web.site_info(queue.queue.store.first)
      @data_store = create_data_store
    end

    def call
      queue.process

      data
    end

    private

    def processor
      proc { |url| process(url) }
    end

    def process(url)
      page = Web.load_page(url)

      return unless page

      mine_data(url, page)
    end

    def mine_data(url, page)
      entity = data_miner.call(url, page)
      if entity
        data_store.save_entity(entity)
        data.push(entity)
      end
    end

    def create_data_store
      dir = "tmp/#{site[:host]}"
      ConcurrentDataSrore.new(dir)
    end
  end
end
