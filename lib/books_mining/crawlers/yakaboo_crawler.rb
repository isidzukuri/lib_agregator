# frozen_string_literal: true

# TODO: overcome DDOS ban

module BooksMining
  class YakabooCrawler
    SITEMAPS_PATH = 'tmp/www.yakaboo.ua/sitemap/*'

    def call
      ap sitemap.size
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
      ebooks_sitemap = WebCrawler::Sitemap.build(
        entry_point: 'https://www.yakaboo.ua/ua/jelektronnye-knigi.html?book_lang=Ukrainskij',
        pages_pattern: Regexp.new("https://www.yakaboo.ua/ua/jelektronnye-knigi.html\\?book_lang=Ukrainskij(?:&|&amp;)p=\\d+"),
        sitemap_items_pattern: Regexp.new("https://www.yakaboo.ua/ua/(?!#{exclude})[A-z0-9-]*.html")
      )

      paper_books_sitemap = WebCrawler::Sitemap.build(
        entry_point: 'https://www.yakaboo.ua/ua/knigi/knigi-na-inostrannyh-jazykah/ukrainskij.html',
        pages_pattern: Regexp.new("https://www.yakaboo.ua/ua/knigi/knigi-na-inostrannyh-jazykah/ukrainskij.html\\?p=\\d+"),
        sitemap_items_pattern: Regexp.new("https://www.yakaboo.ua/ua/(?!#{exclude})[A-z0-9-]*.html")
      )

      WebCrawler::ConcurrentSet.new(ebooks_sitemap.store + paper_books_sitemap.store)
    end

    # def data_miner
    # end

    def exclude
      'jelektronnye-knigi|knigi|audioknigi|dlja-detej-i-mam|knizhnye-aksessuary|bloknoty-i-prinadlezhnosti|board-games|for-school|podarki'
    end
  end
end
