class ExtendedSearchController < ApplicationController

  def new
    @genres = Genre.all
  end

  def show
    redirect_to '/' unless params[:word].present?

    @books = Book.extended_search(query_params)
  end

  private

  def query_params
    query_params = { word: params[:word] }

    if params[:genre].present? && params[:genre].count != Genre.count
      query_params[:genre] = params[:genre]
    end

    if params[:format].present? && params[:format].count != Book::FORMATS.count
      query_params[:format] = params[:format]
    end

    query_params
  end
end
