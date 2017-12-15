class FormatsController < ApplicationController
  def index
    @items = $book_formats
  end

  def show
    # model_method = "find_by_#{params[:key]}".to_sym 
    redirect_to '/formats' unless $book_formats.include?(params[:key])
    @items = Book.where.not(params[:key] => nil).includes(:authors).paginate(page: params[:page], per_page: @per_page)
  end
end
