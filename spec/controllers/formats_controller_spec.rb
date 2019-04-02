require 'rails_helper'
RSpec.describe FormatsController, type: :controller do
  render_views

  let!(:book) { create(:book) }
  let!(:book1) { create(:book, fb2: nil) }

  it 'renders list of formats' do
    get :index

    expect(response.status).to eq 200
    expect(response).to render_template(:index)

    expect(response.body).to include('formats/txt')
    expect(response.body).to include('formats/rtf')
    expect(response.body).to include('formats/doc')
    expect(response.body).to include('formats/pdf')
    expect(response.body).to include('formats/fb2')
    expect(response.body).to include('formats/epub')
    expect(response.body).to include('formats/mobi')
    expect(response.body).to include('formats/djvu')
    expect(response.body).to include('formats/paper')
  end

  it 'renders list of books' do
    get :show, params: { id: 'fb2' }

    expect(response.status).to eq 200
    expect(response).to render_template(:show)

    expect(response.body).to include(book.title)
    expect(response.body).to include("/books/#{book.seo}")
    expect(response.body).not_to include(book1.title)
    expect(response.body).not_to include("/books/#{book1.seo}")
  end
end
