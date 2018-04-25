class QuotesController < ApplicationController
  caches_action :index, expires_in: 12.hour, :cache_path => Proc.new { |c| c.params }


  def index
    @per_page = 15
    # cache_key = "quotes_#{params[:page]}" 
    # @items = cached(cache_key) do
      @items = Quote.order(id: :desc).paginate(page: params[:page], per_page: @per_page).includes(book: :authors).all
    # end
  end

  def show
    @quote = Quote.includes(book: :authors).find(params[:id])
  end
end
