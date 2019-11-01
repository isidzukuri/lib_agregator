# frozen_string_literal: true

RSpec.describe WebCrawler::Sitemap::Builder do
  describe '' do
    let!(:website) { 'http://chtyvo.org.ua/' }

    before(:each) do
      expect_any_instance_of(described_class).to receive(:find_pages_urls)
    end

    it 'does not grep urls from page unless :sitemap_items_pattern given' do
      obj = described_class.new(
        entry_point: website
      )

      VCR.use_cassette('') do
        obj.build

        expect(obj.sitemap.size).to eq(0)
      end
    end

    it 'greps all urls from given page using pattern' do
      obj = described_class.new(
        entry_point: website,
        sitemap_items_pattern: /(authors\/(?!letter).+\/.+\/)"/
      )

      VCR.use_cassette('') do
        obj.build

        expect(obj.sitemap.size).to eq(18)
        expect(obj.sitemap.store.all? { |url| url.include?(website) }).to be_truthy
      end
    end
  end
end
