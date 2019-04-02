class Book
  class ExtendedSearchQuery
    include Tire::Model::Search

    attr_reader :params

    def initialize(params = {})
      @params = params
    end

    def call
      ids = title_filter

      if ids.present?
        query = Book.where(id: ids)
        query = genre_filter(query)
        query = format_filter(query)

        load_data(query)
      else
        []
      end
    end

    private

    def title_filter
      filter = "title:#{params[:word]}"
      search = Tire::Search::Search.new('books')
      search.query { string(filter) }
      search.results.pluck(:id)
    end

    def load_data(query)
      cols = Book.attribute_names - %w(description source domain genre_id)
      query.select(cols).includes(:authors).limit(limit).offset(offset).all
    end

    def genre_filter(query)
      return query unless genre_ids

      query.where(genre_id: genre_ids)
    end

    def format_filter(query)
      return query unless format_params

      query.where(format_params)
    end

    def genre_ids
      if params[:genre].present? && params[:genre].count != Genre.count
        params[:genre]
      end
    end

    def format_params
      @format_params ||= if params[:format].present? && params[:format].count != Book::FORMATS.count
                           formats = []
                           params[:format].each do |frmt|
                             formats << "`#{frmt}` IS NOT NULL"
                           end
                           @format_params = formats.join(' OR ')
                         end
    end

    def limit
      params[:limit] || 100
    end

    def offset
      params[:offset] || 0
    end
  end
end
