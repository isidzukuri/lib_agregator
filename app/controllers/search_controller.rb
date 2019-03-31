class SearchController < ApplicationController
  def index
    if params[:word].present?
      @books = Book.search_by_title(params[:word], @per_page, @offset)
      @authors = Author.search_by_full_name(params[:word])
      @search_word = params[:word]
    else
      redirect_to '/'
    end
  end
end
