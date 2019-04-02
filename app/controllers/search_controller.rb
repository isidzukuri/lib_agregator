class SearchController < ApplicationController
  def index
    if params[:word].present?
      @books = Book::SearchByTitleQuery.new(
        word: params[:word],
        limit: @per_page,
        offset: @offset
      ).call
      @authors = Author.search_by_full_name(params[:word])
      @search_word = params[:word]
    else
      redirect_to :root
    end
  end
end
