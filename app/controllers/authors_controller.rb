class AuthorsController < ApplicationController

  def index
    # @items = Tag.order(:title).all
  end

  def show
    @author = Author.includes(:books).find_by_seo(params[:key])

    @books = @author.books
  end

end