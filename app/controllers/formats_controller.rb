class FormatsController < ApplicationController
  caches_action :index, expires_in: 12.hour
  
  def index
    @items = Book::FORMATS
  end

  def show
    redirect_to formats_path unless Book::FORMATS.include?(params[:id]&.to_sym)
    
    cache_key = "fb_#{params[:id]}_#{params[:page]}" 
    @items = Base::CachedData.call(cache_key, 30.day) do
      Book.select(Book::VIEW_ATTRIBUTES).where.not(params[:id] => nil).paginate(page: params[:page], per_page: @per_page).includes(:authors)
    end
  end
end
