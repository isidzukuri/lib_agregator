class FormatsController < ApplicationController
  caches_action :index, expires_in: 12.hour
  
  def index
    @items = $book_formats
  end

  def show
    # model_method = "find_by_#{params[:key]}".to_sym 
    redirect_to '/formats' unless $book_formats.include?(params[:key])
    cache_key = "fb_#{params[:key]}_#{params[:page]}" 
    @items = cached(cache_key, 30.day) do
      Book.select($book_required_fields).where.not(params[:key] => nil).paginate(page: params[:page], per_page: @per_page).includes(:authors)
    end
  end
end
