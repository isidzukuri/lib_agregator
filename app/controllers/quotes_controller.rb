class QuotesController < ApplicationController
  def index
    @per_page = 15
    cache_key = "quotes_#{params[:page]}" 
    # @items = cached(cache_key) do
      @items = Quote.order(id: :desc).paginate(page: params[:page], per_page: @per_page).includes(book: :authors).all
    # end
  end

  # def show
  #   @list = Quote.find(params[:id])
  #   @items = @list.books.includes(:authors).paginate(page: params[:page], per_page: @per_page).order(:title)
  # end
end
