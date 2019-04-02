require 'rails_helper'
RSpec.describe Api::SearchController, type: :controller do
  render_views

  # let!(:list) { create(:list, status: 'published', books: [create(:book), create(:book)]) }
  # let!(:unpublished_list) { create(:list, status: 'unpublished') }

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

  # api_search GET    /api/search(.:format)    api/search#index {:format=>"json"}
  # api_paper GET    /api/paper(.:format)

  # it 'renders list of books' do
  #   get :show, params: { id: list.seo }

  #   expect(response.status).to eq 200
  #   expect(response).to render_template(:show)

  #   expect(response.body).to include(list.title)
  #   expect(response.body).to include(list.books[0].title)
  #   expect(response.body).to include("/books/#{list.books[0].seo}")
  #   expect(response.body).to include(list.books[1].title)
  #   expect(response.body).to include("/books/#{list.books[1].seo}")
  # end
end
