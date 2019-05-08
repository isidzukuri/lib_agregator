class Author
  class AutocompleteQuery
    attr_reader :params

    def initialize(params = {})
      @params = params
    end

    def call
      Author.where("LOWER(full_name) LIKE :query OR seo LIKE :query OR LOWER(uk) LIKE :query", query: like)
              .limit(limit)
    end

    private

    def limit
      params[:limit] || 20
    end

    def like
      "%#{params[:word]}%"
    end
  end
end
