require 'rails_helper'
RSpec.describe ArticlesController, type: :controller do
  render_views

  let!(:article) { create(:article, status: 'published',) }
  let!(:unpublished_article) { create(:article, status: 'unpublished') }

  it 'renders list of articles' do
    get :index

    expect(response.status).to eq 200
    expect(response).to render_template(:index)

    expect(response.body).to include(article.title)
    expect(response.body).to include("/articles/#{article.seo}")
    expect(response.body).not_to include(unpublished_article.title)
    expect(response.body).not_to include("/articles/#{unpublished_article.seo}")
  end

  it 'renders article' do
    get :show, params: { id: article.seo }

    expect(response.status).to eq 200
    expect(response).to render_template(:show)

    expect(response.body).to include(article.title)
    expect(response.body).to include(article.text)
  end
end
