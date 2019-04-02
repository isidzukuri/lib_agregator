require 'rails_helper'
RSpec.describe BooksController, type: :controller do
  render_views

  let!(:tag) { create(:tag) }
  let!(:book) { create(:book, tags: [tag]) }

  it '' do
    get :show, params: { id: book.seo }

    expect(response.status).to eq 200
    expect(response).to render_template(:show)

    expect(response.body).to include(book.description)
    expect(response.body).to include(book.title)
    expect(response.body).to include(book.paper)
    expect(response.body).to include(book.txt)
    expect(response.body).to include(book.rtf)
    expect(response.body).to include(book.doc)
    expect(response.body).to include(book.pdf)
    expect(response.body).to include(book.fb2)
    expect(response.body).to include(book.epub)
    expect(response.body).to include(book.mobi)
    expect(response.body).to include(book.djvu)
    expect(response.body).to include(book.genre.title)
    expect(response.body).to include("genres/#{book.genre.seo}")
    expect(response.body).to include(book.tags.first.uk)
    expect(response.body).to include("tags/#{book.tags.first.seo}")
    expect(response.body).to include(book.authors.pluck(:full_name).join)
    expect(response.body).to include("authors/#{book.authors.first.seo}")
  end
end
