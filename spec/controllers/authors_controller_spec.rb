require 'rails_helper'
RSpec.describe AuthorsController, type: :controller do
  render_views

  let!(:author) { create(:author) }
  let!(:book) { create(:book, authors: [author]) }

  it 'renders list of authors' do
    get :index

    expect(response.status).to eq 200
    expect(response).to render_template(:index)

    expect(response.body).to include('Автори')
    expect(response.body).to include(author.full_name)
    expect(response.body).to include("/authors/#{author.seo}")
  end

  it 'renders list of books' do
    get :show, params: { id: author.seo }

    expect(response.status).to eq 200
    expect(response).to render_template(:show)

    expect(response.body).to include(author.title)
    expect(response.body).to include(book.title)
    expect(response.body).to include("/books/#{book.seo}")
    expect(response.body).to include('<span class="label label-warning">fb2</span>')
  end
end
