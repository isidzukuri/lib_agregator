module Bibliotheca
class Book
  class AutocompleteWithSeoQuery
    attr_reader :params

    def initialize(params = {})
      @params = params
    end

    def call
      Book.where("LOWER(title) LIKE :query OR seo LIKE :query", query: like)
              .limit(limit).includes(:authors)
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
end
