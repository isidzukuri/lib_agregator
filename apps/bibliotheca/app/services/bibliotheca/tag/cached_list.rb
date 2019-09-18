module Bibliotheca
class Tag
  class CachedList
    DEFAULT_LIMIT = 300

    def initialize(params)
      @params = params
    end

    attr_accessor :params

    def call
      Base::CachedData.call(cache_key, 30.day) do
        Tag.order(:title).paginate(page: page, per_page: limit).all
      end
    end

    private

    def cache_key
      "tags_#{page}"
    end

    def limit
      params[:limit] || DEFAULT_LIMIT
    end

    def page
      params[:page] || 1
    end
  end
end
end
