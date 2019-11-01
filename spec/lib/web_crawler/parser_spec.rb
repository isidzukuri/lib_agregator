# frozen_string_literal: true

RSpec.describe WebCrawler::Parser do
  describe '' do
    class DummyDataMiner
      def call(url, html)
        {some_key: 'parsed_data'}
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

        expect(res.store).to eq([{some_key: 'parsed_data'}])
      end
    end

  end
end
