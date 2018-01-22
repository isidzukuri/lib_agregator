class TagsController < ApplicationController
  caches_action :index, expires_in: 12.hour

  def index
    @items = $cache.read('tags')
    unless @items
      @items = Tag.order(:title).all
      $cache.write('tags', @items, expires_in: 5.day)
    end
  end

  def show
    @tag = Tag.find_by_seo(params[:key])
    @items = @tag.books.select($book_required_fields).includes(:authors).paginate(page: params[:page], per_page: @per_page)
  end
end
