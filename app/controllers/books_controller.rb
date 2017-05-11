class BooksController < ApplicationController
  
  def show
    @book = Book.includes(:authors, :tags, :genre).find_by_seo(params[:key])
  end

  def autocomplete_with_seo
    items = Book.autocomplete_with_seo(params[:term])
    render json: items, each_serializer: BookAutocompleteSerializer
  end
end
