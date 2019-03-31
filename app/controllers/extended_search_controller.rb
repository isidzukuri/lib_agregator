class ExtendedSearchController < ApplicationController

  def new
    @genres = Genre.all
  end

  def show
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
