require 'rails_helper'
RSpec.describe GenresController, type: :controller do
  render_views

  let!(:genre) { create(:genre) }
  let!(:book) { create(:book, genre: genre) }

  it 'renders list of genres' do
    get :index

    expect(response.status).to eq 200
    expect(response).to render_template(:index)

    expect(response.body).to include(genre.title)
    expect(response.body).to include("/genres/#{genre.seo}")
  end

  it 'renders list of books' do
    get :show, params: { id: genre.seo }

    expect(response.status).to eq 200
    expect(response).to render_template(:show)

    expect(response.body).to include(genre.title)
    expect(response.body).to include(book.title)
    expect(response.body).to include("/books/#{book.seo}")
    expect(response.body).to include('<span class="label label-warning">fb2</span>')
  end
end
