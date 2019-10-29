# frozen_string_literal: true

module WebCrawler
  module Sitemap
    class Builder
      include WebCrawler::Web

      InvalidUrlError = Class.new(StandardError)

      attr_reader :queue, :sitemap, :params, :site

      def initialize(params)
        @params = params
        @sitemap = ConcurrentSet.new
        @queue = ProcessableQueue.new(processor)
      end

      def build
        @site = site_info(params[:entry_point])
        queue.push(params[:entry_point])
        queue.process
        save_sitemap
        sitemap
      end

      private

      def processor
        proc { |url| find_links(url) }
      end

      def find_links(url)
        page = load_page(url)

        return unless page

        sitemap_urls = find_sitemap_urls(page)
        pages_urls = find_pages_urls(page)

        sitemap.push(sitemap_urls)
        queue.push(pages_urls)
      end

      def find_sitemap_urls(html)
        return [] unless params[:sitemap_items_pattern]

        hrefs = html.scan(params[:sitemap_items_pattern]).flatten

        urls_from(hrefs)
      end

      def find_pages_urls(html)
        return [] unless params[:pages_pattern]

        hrefs = html.scan(params[:pages_pattern]).flatten

        urls_from(hrefs)
      end

      def urls_from(hrefs)
        urls = []

        hrefs.each do |href|
          href = decorate_href(href)

          next unless href.include?(site[:host])

          urls << href
        end

        urls
      end

      def decorate_href(href)
        uri = URI(URI.encode(href))
        if uri.host.nil?
          uri.host = site[:host]
          uri.scheme = site[:scheme]
          uri.path = '/' + uri.path unless uri.path[0] == '/'
        end
        uri.to_s
      end

      def save_sitemap
        time = Time.now.strftime('%d.%m.%Y')
        path = "tmp/#{site[:host]}/sitemap/#{time}.csv"
        FileHelpers.write path, sitemap.store.to_csv
      end
    end
  end
end
