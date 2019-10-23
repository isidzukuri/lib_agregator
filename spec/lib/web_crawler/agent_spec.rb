# frozen_string_literal: true

RSpec.describe WebCrawler::Agent do
  # let!(:book1) { create(:book, fb2: nil) }

  describe 'get' do
    let!(:invalid_url) { 'https://www.google.com/invalid' }
    let!(:url) { 'https://www.google.com/' }
    let!(:obj) { described_class.new }

    it 'returns body from url' do
      VCR.use_cassette('google_index') do
        res = obj.get(url)

        expect(res.success?).to be_truthy
        expect(res.page).to be_a(String)
      end
    end

    it 'returns errors if rquest failed' do
      VCR.use_cassette('google_404') do
        res = obj.get(invalid_url)

        expect(res.success?).to be_falsey
        expect(res.errors).to eq(['404 Not Found'])
      end
    end

    context 'use cache' do
      let!(:obj) { described_class.new(use_cache: true) }

      it 'returns body from url' do
        VCR.use_cassette('google_index') do
          expect(WebCrawler::Agent::CACHE).to receive(:read)
          expect(WebCrawler::Agent::CACHE).to receive(:write)

          res = obj.get(url)

          expect(res.success?).to be_truthy
          expect(res.page).to be_a(String)
        end
      end

      it 'returns errors if rquest failed' do
        VCR.use_cassette('google_404') do
          expect(WebCrawler::Agent::CACHE).to receive(:read)
          expect(WebCrawler::Agent::CACHE).not_to receive(:write)

          res = obj.get(invalid_url)

          expect(res.success?).to be_falsey
          expect(res.errors).to eq(['404 Not Found'])
        end
      end
    end
  end
end
