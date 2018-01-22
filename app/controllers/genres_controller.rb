class GenresController < ApplicationController
  def index
    @items = Genre.all
  end

  def show
    @genre = Genre.find_by_seo(params[:key])
    cache_key = "genre_#{params[:key]}_#{params[:page]}" 
    @items = $cache.read(cache_key)
    unless @items
      @items = @genre.books.select($book_required_fields).includes(:authors).paginate(page: params[:page], per_page: @per_page)
      $cache.write(cache_key, @items, expires_in: 30.day)
    end
  end
  
end
