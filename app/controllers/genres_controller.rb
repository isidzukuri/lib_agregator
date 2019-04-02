class GenresController < ApplicationController
  caches_action :index, expires_in: 12.hour
  
  def index
    @items = Genre.all
  end

  def show
    @genre = Genre.find_by_seo(params[:id])
    cache_key = "genre_#{params[:id]}_#{params[:page]}" 
    @items = cached(cache_key, 30.day) do
      @genre.books.select($book_required_fields).includes(:authors).paginate(page: params[:page], per_page: @per_page)
    end
  end
  
end
