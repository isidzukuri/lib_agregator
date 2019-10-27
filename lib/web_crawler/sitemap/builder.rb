module WebCrawler
  module Sitemap
    class Builder

      InvalidUrlError = Class.new(StandardError)

      attr_reader :queue, :sitemap, :params, :site

      #   {
      #     entry_point: entry_point,
      #     pages_pattern: /\/authors\//
      #     sitemap_items_pattern: /authors/
      #   }

      def initialize(params)
        @params = params
        @sitemap = ConcurrentSet.new
        @queue = ProcessableQueue.new(processor)
      end

      def build
        site_info(params[:entry_point])

        queue.push(params[:entry_point])

        queue.process

        save_sitemap
        # print step info
      end

      private

      def site_info(url)
        uri = URI(url)

        raise(InvalidUrlError, "'url' does not contain host") unless uri.host

        @site = {host: uri.host, scheme: uri.scheme}
      end

      def processor
        Proc.new {|url| find_links(url) }
      end

      def find_links(url)
        agent = Agent.new
        res = agent.get(url)

        unless res.success?
          ConcurrentLog.put_in_bucket(url, res.errors.to_s)

          return
        end

        ConcurrentLog.put_in_bucket(url, 'looking for urls')
        sitemap_urls = find_sitemap_urls(res.page)
        pages_urls = find_pages_urls(res.page)

        sitemap.push(sitemap_urls)
        queue.push(pages_urls)
        ConcurrentLog.puts_bucket(url)
      end

      def find_sitemap_urls(html)
        hrefs = html.scan(sitemap_items_pattern).flatten

        urls_from(hrefs)
      end

      def find_pages_urls(html)
        hrefs = html.scan(pages_pattern).flatten

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

      def pages_pattern
        @pages_pattern ||= build_link_regexp(params[:pages_pattern])
      end

      def sitemap_items_pattern
        @sitemap_items_pattern ||= build_link_regexp(params[:sitemap_items_pattern])
      end

      def build_link_regexp pattern = ''
        /<a\s*href="(?=[^"]*#{pattern})([^"]*)">/
      end

      def save_sitemap
        time = Time.now.strftime("%d.%m.%Y_%H-%M")
        path = "tmp/#{site[:host]}/sitemap/#{time}.csv"
        FileHelpers.write path, sitemap.store.to_csv
      end

    end
  end
end