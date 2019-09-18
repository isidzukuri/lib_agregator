module Bibliotheca
class Format::CachedList
  def initialize(params)
    @params = params
  end

  attr_accessor :params

  def call
    Base::CachedData.call(cache_key, 30.day) do
      Book.select(Book::VIEW_ATTRIBUTES).where.not(params[:key] => nil).paginate(page: page, per_page: limit).includes(:authors)
    end
  end

  private

  def cache_key
    "fb_#{params[:key]}_#{page}"
  end

  def limit
    params[:limit] || 100
  end

  def page
    params[:page] || 1
  end
end
end
