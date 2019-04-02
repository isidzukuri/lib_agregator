require 'rails_helper'
RSpec.describe Api::SearchController, type: :controller do
  render_views

  let!(:book) { create(:book, title: 'Some title', domain: 'chtyvo.org.ua', source: '/books/some_id') }
  let!(:book_paper) { create(:book, title: 'Some paper title', source: '/books/paper_id') }

  let(:parsed_body) { JSON.parse(response.body) }

  context 'GET /api/search' do
    it '' do
      expect(Book).to receive(:search_by_title).and_return([book])

      get :index, params: { word: 'some' }

      expect(parsed_body[0]['title']).to eq(book.title)
      expect(parsed_body[0]['author_title']).to eq(book.authors.first.full_name)
      expect(parsed_body[0]['source']).to eq('http://chtyvo.org.ua/books/some_id')
      expect(parsed_body[0].keys).to eq(%w(id title source author_title cover paper))
    end
  end

  context 'GET /api/paper' do
    it '' do
      expect(Book).to receive(:search_by_title).and_return([book, book_paper])

      get :paper, params: { word: 'some' }

      expect(parsed_body[0].keys).to eq(%w(id title source author_title cover paper))
      expect(parsed_body.length).to eq(2)
      expect(parsed_body[0]['title']).to eq(book.title)
      expect(parsed_body[0]['author_title']).to eq(book.authors.first.full_name)
      expect(parsed_body[0]['source']).to eq('http://chtyvo.org.ua/books/some_id')
    end
  end
end
