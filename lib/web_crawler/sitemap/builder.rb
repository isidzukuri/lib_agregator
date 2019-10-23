module WebCrawler
  module Sitemap
    class Builder

      # def build
      #   get_start_page
      #   find_links
      #   save urls
      #   if usefull hrefs
      #     add hrefs to processing_queue
      #     run threads
      #
      #   return sitemap
      # end
      #
      # def get_start_page
      #   agent = agents.availiable
      #   agent.get(start_page)
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
      #       agent.new
      #       agent.get processing_queue.pop
      #       save urls
      #       add hrefs to processing_queue
      #
      # end

    end
  end
end
