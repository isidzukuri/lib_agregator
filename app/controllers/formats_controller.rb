class FormatsController < ApplicationController
  caches_action :index, expires_in: 12.hour
  
  def index
    @items = Book::FORMATS
  end

  def show
    redirect_to '/formats' unless Book::FORMATS.include?(params[:id])
    cache_key = "fb_#{params[:id]}_#{params[:page]}" 
    @items = cached(cache_key, 30.day) do
      Book.select(Book::REQUIRED_FIELDS).where.not(params[:id] => nil).paginate(page: params[:page], per_page: @per_page).includes(:authors)
    end
  end
end
