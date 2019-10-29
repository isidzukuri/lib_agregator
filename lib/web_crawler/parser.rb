# frozen_string_literal: true

module WebCrawler
  class Parser
    attr_reader :queue, :data, :data_miner

    def initialize(sitemap, data_miner)
      @data_miner = data_miner
      @data = ConcurrentSet.new
      @queue = ProcessableQueue.new(processor, sitemap)
    end

    def call
      queue.process

      data
    end

    def processor
      proc { |url| process(url) }
    end

    def process(url)
      page = load_page(url)

      return unless page

      mine_data(url, page)
    end

    def load_page(url)
      agent = Agent.new
      res = agent.get(url)

      if res.success?
        Log.puts_success(url)
      else
        message = "#{url}: #{res.errors}"
        Log.puts_alert(message)
      end

      res.page
    end

    def mine_data(url, page)
      entity = data_miner.call(url, page)
      if entity
        save_to_csv(entity)
        data.push(entity)
      end
    end

    def save_to_csv(entity)
      # todo
      # CSVWriter.init file with columns (entity) unless csv exists
      # CSVWriter.add(entity)
    end
  end
end
