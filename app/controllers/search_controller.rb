class SearchController < ApplicationController
  def index
    if params[:word].present?
      @books = Book.search_by_title(params[:word], @per_page, @offset)
      @authors = Author.search_by_full_name(params[:word])
    else
      redirect_to '/'
    end
  end

  def extended_form
    @genres = Genre.all
  end

  def extended_search_results
    redirect_to '/' unless params[:word].present?

    query_params = { word: params[:word] }

    if params[:genre].present? && params[:genre].count != Genre.count
      query_params[:genre] = params[:genre]
    end

    if params[:format].present? && params[:format].count != $book_formats.count
      query_params[:format] = params[:format]
    end

    @books = Book.extended_search(query_params)
  end
end
