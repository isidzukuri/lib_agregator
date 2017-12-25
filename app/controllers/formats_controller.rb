class FormatsController < ApplicationController
  def index
    @items = $book_formats
  end

  def show
    # model_method = "find_by_#{params[:key]}".to_sym 
    redirect_to '/formats' unless $book_formats.include?(params[:key])
    cache_key = "fb_#{params[:key]}_#{params[:page]}" 
    @items = $cache.read(cache_key)
    unless items
      @items = Book.select($book_required_fields).where.not(params[:key] => nil).paginate(page: params[:page], per_page: @per_page).includes(:authors)
      $cache.write(cache_key, @items, expires_in: 1.day)
    end
  end
end
