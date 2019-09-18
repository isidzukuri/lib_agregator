module Bibliotheca
class Book
  class ReadAlso
    def initialize(params)
      @book = params[:book]
    end

    attr_accessor :book

    def call
      tags_ids = book['tags_ids']&.split(',')
      return nil unless tags_ids

      tags_ids = tags_ids.map(&:to_i).sort
      cache_key = "also_#{tags_ids[0..3].join}_2"
      Base::CachedData.call(cache_key, 10.day) do
        Book::ReadAlsoQuery.new(book_id: book[:id], tags_ids: tags_ids, language: book[:language]).call
      end
    end
  end
end
end
