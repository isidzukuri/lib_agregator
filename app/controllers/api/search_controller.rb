class Api::SearchController < ApplicationController

  def index
    if params[:word].present?
      books = Book.search_by_title(params[:word], @per_page, @offset)
      books = books.select{|b| b.domain == 'chtyvo.org.ua'}
      render json: books, each_serializer: Api::BookInListSerializer
    end

  end

end