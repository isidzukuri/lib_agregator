class TagsController < ApplicationController
  # caches_action :index, expires_in: 12.hour

  def index
    @all_items = cached('tags') do
      Tag.order(:title).all
    end
    
    @per_page = 300
    cache_key = "tags_#{params[:page]}" 
    @items = cached(cache_key, 30.day) do
      Tag.order(:title).paginate(page: params[:page], per_page: @per_page).all
    end
  end

  def show
    @tag = Tag.find_by_seo(params[:key])
    cache_key = "tag_#{params[:key]}_#{params[:page]}" 
    @items = cached(cache_key) do
      @tag.books.select($book_required_fields).includes(:authors).paginate(page: params[:page], per_page: @per_page)
    end
  end

end
