class Book
  class SearchByTitleQuery
    include Tire::Model::Search
    
    COLLECTION_KEY = 'books'.freeze

    attr_reader :params

    def initialize(params = {})
      @params = params
    end

    def call
      title_filter = "title:#{params[:word]}"
      search = Tire::Search::Search.new(COLLECTION_KEY, load: true)
      search.query { string(title_filter) }

      pointers = search.results
      pointers = pointers.drop(offset) if offset > 0
      pointers = pointers.first(limit)

      ActiveRecord::Associations::Preloader.new.preload(pointers, :authors)

      pointers
    end

    private

    def limit
      params[:limit] || 100
    end

    def offset
      params[:offset] || 0
    end
  end
end
