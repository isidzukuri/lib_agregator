module Bibliotheca
class Book
  class ReadAlsoQuery
    attr_reader :params

    def initialize(params = {})
      @params = params
    end

    def call
      items = []
      return items unless params[:tags_ids]

      sql = <<-SQL
            SELECT DISTINCT
              books.id,
              books.title,
              books.seo,
              books.optimized_cover
            FROM books_tags
            INNER JOIN books ON books_tags.book_id = books.id
            WHERE
              books_tags.tag_id IN(#{params[:tags_ids].join(',')})
                AND books.optimized_cover IS NOT NULL
                AND books.id > #{random_id}
                AND books.is_copy = false #{language}
            LIMIT #{limit}
      SQL

      ActiveRecord::Base.connection.exec_query(sql).to_hash
    end

    private

    def limit
      params[:limit] || 6
    end

    def language
      params[:language] ? " AND books.language = '#{params[:language]}'" : ''
    end

    def random_id
      rand(1..params[:book_id].to_i)
    end
  end
end
end
