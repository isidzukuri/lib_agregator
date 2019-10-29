# frozen_string_literal: true

RSpec.describe WebCrawler::Parser do
  describe '' do
    class DummyDataMiner
      def call(url, html)
        'parsed_data'
      end
    end

    let!(:sitemap) do
      sitemap = WebCrawler::ConcurrentSet.new
      sitemap.push('http://chtyvo.org.ua/')
      sitemap
    end

    let!(:obj) do
      described_class.new(sitemap, DummyDataMiner.new)
    end

    it 'processes each item from sitemap' do
      VCR.use_cassette('') do
        res = obj.call

        expect(res.store).to eq(['parsed_data'])
      end
    end

  end
end
