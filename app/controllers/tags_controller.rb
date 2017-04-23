class TagsController < ApplicationController
  def index
    @items = Tag.order(:title).paginate(page: params[:page], per_page: @per_page).all
  end

  def show
    @tag = Tag.find_by_seo(params[:key])
    @items = @tag.books.includes(:authors).paginate(page: params[:page], per_page: @per_page)
  end
end
