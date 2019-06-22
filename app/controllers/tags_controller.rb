class TagsController < ApplicationController
  # caches_action :index, expires_in: 12.hour

  def index
    @all_items = Base::CachedData.call('tags') do
      Tag.order(:title).all
    end

    @items = Tag::CachedList.new(page: params[:page]).call
  end

  def show
    @tag = Tag.find_by_seo(params[:id])
    cache_key = "tag_#{params[:id]}_#{params[:page]}"
    @items = Base::CachedData.call(cache_key) do
      @tag.books.select(Book::VIEW_ATTRIBUTES).includes(:authors).paginate(page: params[:page], per_page: @per_page)
    end
  end
end
