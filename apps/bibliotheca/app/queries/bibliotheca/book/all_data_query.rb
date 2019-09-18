module Bibliotheca
class Book
  class AllDataQuery
    attr_reader :params

    def initialize(params = {})
      @params = params
    end

    def call
      return book_data.with_indifferent_access, tags_data, authors_data
    end

    private

    def book_data
      return @book_data if @book_data

      sql = <<-SQL
        SELECT
          books.*,
          genres.title as genre_title,
          genres.seo as genre_seo,
          GROUP_CONCAT(DISTINCT authors_books.author_id SEPARATOR ',') as authors_ids,
          GROUP_CONCAT(DISTINCT books_tags.tag_id SEPARATOR ',') as tags_ids
        FROM books
        LEFT JOIN genres ON genres.id = books.genre_id
        LEFT JOIN authors_books ON authors_books.book_id = books.id
        LEFT JOIN books_tags ON books_tags.book_id = books.id
        WHERE books.seo = '#{params[:seo]}'
        GROUP BY books.id
      SQL

      @book_data = ActiveRecord::Base.connection.exec_query(sql).to_hash[0]
    end

    def tags_data
      if book_data&.fetch('tags_ids').present?
        Tag.where(id: book_data['tags_ids'].split(',')).to_a
      else
        []
      end
    end

    def authors_data
      if book_data&.fetch('authors_ids').present?
        Author.where(id: book_data['authors_ids'].split(',')).to_a
      else
        []
      end
    end
  end
end
end
