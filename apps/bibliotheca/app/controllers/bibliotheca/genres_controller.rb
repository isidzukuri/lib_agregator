module Bibliotheca
class GenresController < ApplicationController
  caches_action :index, expires_in: 12.hour

  def index
    @items = Genre.all
  end

  def show
    @genre = Genre.find_by_seo(params[:id])

    @items = Genre::CachedList.new(genre: @genre, key: params[:id], page: params[:page], limit: @per_page).call
  end
end
end
