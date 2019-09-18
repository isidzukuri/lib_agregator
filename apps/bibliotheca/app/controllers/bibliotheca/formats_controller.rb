module Bibliotheca
class FormatsController < ApplicationController
  caches_action :index, expires_in: 12.hour

  def index
    @items = Book::FORMATS
  end

  def show
    redirect_to formats_path unless Book::FORMATS.include?(params[:id]&.to_sym)

    @items = Format::CachedList.new(key: params[:id], page: params[:page], limit: @per_page).call
  end
end
end
