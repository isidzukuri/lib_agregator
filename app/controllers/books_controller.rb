class BooksController < ApplicationController
  
  def show
    @book, @tags, @authors = Book.all_data(params[:id])
    # @book = Book.includes(:authors, :tags, :genre).find_by_seo(params[:id])
    redirect_to(:root, status: 410) unless @book
    redirect_to(:root, status: 410) if @book && @book['hide']
    # @read_also = @book.read_also(6) if @book
    @read_also = read_also(@book)
  end

  def autocomplete_with_seo
    items = Book.autocomplete_with_seo(params[:term])
    render json: items, each_serializer: BookAutocompleteSerializer
  end

  private

  def read_also book
    tags_ids = book['tags_ids']&.split(',')
    return nil unless tags_ids
      
    tags_ids = tags_ids.map(&:to_i).sort
    cache_key = "also_#{tags_ids[0..3].join}_2" 
    cached(cache_key, 10.day) do
      Book.read_also book, tags_ids, book['language'], 6
    end
  end
end
