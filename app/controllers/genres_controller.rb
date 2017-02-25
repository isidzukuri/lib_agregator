class GenresController < ApplicationController

  def index
    @items = Genre.all
  end

  def show
    @genre = Genre.find_by_seo(params[:key])
    @items = @genre.books.includes(:authors).limit(@per_page).offset(@offset)
    @items_total = @genre.books.count
  end

end
