# frozen_string_literal: true

module BooksMining
  class ChtyvoCrawler
    SITEMAPS_PATH = 'tmp/chtyvo.org.ua/sitemap/*'

    def call
      WebCrawler::Parser.new(sitemap, data_miner).call
      ChtyvoImporter.new.call if sitemap.size > 0
    end

    private

    def previous_sitemap
      return @previous_sitemap if @previous_sitemap

      files_sorted_by_time = Dir[SITEMAPS_PATH].sort_by { |f| File.mtime(f) }

      return nil if files_sorted_by_time.length == 1

      path = files_sorted_by_time[(files_sorted_by_time.length - 2)]

      @previous_sitemap = path ? CSV.read(path)&.flatten : nil
    end

    def sitemap
      return @sitemap if @sitemap
      sitemap = WebCrawler::Sitemap.build(
        entry_point: 'https://chtyvo.org.ua/',
        pages_pattern: %r{(?:https://chtyvo.org.ua/)?(?:genre/[A-z]*/books|authors/letter/\d+/\p{L})(?:/page-\d+)?},
        sitemap_items_pattern: %r{((?:https://chtyvo.org.ua/)?authors/(?!letter).+/.+/)"}
      )
      # sitemap = WebCrawler::Sitemap.from_file('tmp/chtyvo.org.ua/sitemap/30.10.2019.csv')

      if previous_sitemap
        new_sitemap = WebCrawler::ConcurrentSet.new

        items = sitemap.store - previous_sitemap

        new_sitemap.push(items)

        sitemap = new_sitemap
      end

      @sitemap = sitemap
    end

    def data_miner
      ChtyvoDataMiner.new
    end
  end
end
