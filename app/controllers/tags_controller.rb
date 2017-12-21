class TagsController < ApplicationController
  caches_action :index, expires_in: 12.hour

  def index
    # @items = Tag.order(:title).paginate(page: params[:page], per_page: @per_page).all
    @items = Tag.order(:title).all
  end

  def show
    @tag = Tag.find_by_seo(params[:key])
    @items = @tag.books.select($book_required_fields).includes(:authors).paginate(page: params[:page], per_page: @per_page)
  end
end
