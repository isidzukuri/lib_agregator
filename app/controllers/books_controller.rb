class BooksController < ApplicationController
  def show
    @book, @tags, @authors = Book::AllDataQuery.new(seo: params[:id]).call

    redirect_to(:root, status: 410) unless @book
    redirect_to(:root, status: 410) if @book['hide']

    @read_also = read_also(@book)
  end

  def autocomplete_with_seo
    items = Book::AutocompleteWithSeoQuery.new(word: params[:term]).call

    render json: items, each_serializer: BookAutocompleteSerializer
  end

  private

  def read_also book
    tags_ids = book['tags_ids']&.split(',')
    return nil unless tags_ids
      
    tags_ids = tags_ids.map(&:to_i).sort
    cache_key = "also_#{tags_ids[0..3].join}_2" 
    cached(cache_key, 10.day) do
      Book::ReadAlsoQuery.new(book_id: book[:id], tags_ids: tags_ids, language: book[:language]).call
    end
  end
end
