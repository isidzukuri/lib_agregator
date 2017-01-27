class TagsController < ApplicationController

  def index
    @items = Tag.order(:title).all
  end

  def show
    # @tag = Tag.includes(:books).find_by_seo(params[:key])
    @tag = Tag.includes(books: [:authors]).find_by_seo(params[:key])

    @books = @tag.books
  end

end