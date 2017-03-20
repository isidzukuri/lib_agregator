class TagsController < ApplicationController
  def index
    @items = Tag.order(:title).limit(@per_page).offset(@offset).all
    @items_total = Tag.count
  end

  def show
    @tag = Tag.find_by_seo(params[:key])
    @items = @tag.books.includes(:authors).limit(@per_page).offset(@offset)
    @items_total = @tag.books.count
  end
end
