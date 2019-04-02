require 'rails_helper'
RSpec.describe TagsController, type: :controller do
  render_views

  let!(:tag) { create(:tag) }
  let!(:book) { create(:book, tags: [tag]) }

  it 'renders list of tags' do
    get :index

    expect(response.status).to eq 200
    expect(response).to render_template(:index)

    expect(response.body).to include(tag.title)
    expect(response.body).to include("/tags/#{tag.seo}")
  end

  it 'renders list of books' do
    get :show, params: { id: tag.seo }

    expect(response.status).to eq 200
    expect(response).to render_template(:show)

    expect(response.body).to include(tag.uk)
    expect(response.body).to include(book.title)
    expect(response.body).to include("/books/#{book.seo}")
    expect(response.body).to include('<span class="label label-warning">fb2</span>')
  end
end
