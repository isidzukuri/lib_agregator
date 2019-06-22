class Genre
  class CachedList
    def initialize(params)
      @params = params
    end

    attr_accessor :params

    def call
      Base::CachedData.call(cache_key, 30.day) do
        genre.books.select(Book::VIEW_ATTRIBUTES).includes(:authors).paginate(page: page, per_page: limit)
      end
    end

    private

    def cache_key
      "genre_#{params[:key]}_#{page}"
    end

    def limit
      params[:limit] || 100
    end

    def page
      params[:page] || 1
    end

    def genre
      params[:genre] || Genre.find_by_seo(params[:key])
    end
  end
end
