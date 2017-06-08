class ListsController < ApplicationController
  def index
    @items = List.order(id: :desc).where(status: 'published').paginate(page: params[:page], per_page: @per_page).all
  end

  def show
    @list = List.find_by_seo(params[:key])
    @items = @list.books.includes(:authors).paginate(page: params[:page], per_page: @per_page).order(:title)
  end
end
