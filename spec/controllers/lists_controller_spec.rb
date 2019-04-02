require 'rails_helper'
RSpec.describe ListsController, type: :controller do
  render_views

  let!(:list) { create(:list, status: 'published', books: [create(:book), create(:book)]) }
  let!(:unpublished_list) { create(:list, status: 'unpublished') }

  it 'renders list of genres' do
    get :index

    expect(response.status).to eq 200
    expect(response).to render_template(:index)

    expect(response.body).to include(list.title)
    expect(response.body).to include("/lists/#{list.seo}")
    expect(response.body).not_to include(unpublished_list.title)
    expect(response.body).not_to include("/lists/#{unpublished_list.seo}")
  end

  it 'renders list of books' do
    get :show, params: { id: list.seo }

    expect(response.status).to eq 200
    expect(response).to render_template(:show)

    expect(response.body).to include(list.title)
    expect(response.body).to include(list.books[0].title)
    expect(response.body).to include("/books/#{list.books[0].seo}")
    expect(response.body).to include(list.books[1].title)
    expect(response.body).to include("/books/#{list.books[1].seo}")
  end
end
