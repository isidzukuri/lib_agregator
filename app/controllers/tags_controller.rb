class TagsController < ApplicationController
  def index
    @items = Tag.order(:title).paginate(page: params[:page], per_page: @per_page).all
  end

  def show
    @tag = Tag.find_by_seo(params[:key])
    cache_key = "tag_#{params[:key]}_#{params[:page]}" 
    @items = $cache.read(cache_key)
    unless @items
      @items = @tag.books.select($book_required_fields).includes(:authors).paginate(page: params[:page], per_page: @per_page)
      $cache.write(cache_key, @items, expires_in: 30.day)
    end
  end
end
