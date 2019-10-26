# frozen_string_literal: true

RSpec.describe WebCrawler::Sitemap::Builder do

  describe '' do
    let!(:website) { 'http://chtyvo.org.ua/' }
    # let!(:obj) do
    #   described_class.new(
    #     entry_point: entry_point,
    #     pages_pattern: /\/authors\//
    #     sitemap_items_pattern: /authors/
    #   )
    # end

    before(:each) do
      expect_any_instance_of(described_class).to receive(:find_pages_urls)
    end

    it 'greps all urls from given page' do
      obj = described_class.new(
        entry_point: website
      )

      VCR.use_cassette('') do
        obj.build

        expect(obj.sitemap.size).to eq(78)
        expect(obj.sitemap.store.all? { |url| url.include?(website) }).to be_truthy
      end
    end

    it 'greps all urls from given page using pattern' do
      obj = described_class.new(
        entry_point: website,
        sitemap_items_pattern: /authors/
      )

      VCR.use_cassette('') do
        obj.build

        expect(obj.sitemap.size).to eq(50)
      end
    end

  end
end
