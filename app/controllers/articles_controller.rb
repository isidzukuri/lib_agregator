class ArticlesController < ApplicationController
  def index
    @items = Article.order(id: :desc).where(status: 'published').paginate(page: params[:page], per_page: @per_page).all
  end

  def show
    @article = Article.find_by_seo(params[:id])
  end
end
