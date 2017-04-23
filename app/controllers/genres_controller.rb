class GenresController < ApplicationController
  def index
    @items = Genre.all
  end

  def show
    @genre = Genre.find_by_seo(params[:key])
    @items = @genre.books.includes(:authors).paginate(page: params[:page], per_page: @per_page)
  end
end
