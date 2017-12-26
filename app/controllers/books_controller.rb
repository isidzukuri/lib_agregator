class BooksController < ApplicationController
  
  def show
    @book = Book.includes(:authors, :tags, :genre).find_by_seo(params[:key])
    redirect_to(:root, status: 410) unless @book
    redirect_to(:root, status: 410) if @book && @book.hide
    @read_also = @book.read_also(6) if @book
  end

  def autocomplete_with_seo
    items = Book.autocomplete_with_seo(params[:term])
    render json: items, each_serializer: BookAutocompleteSerializer
  end
end
