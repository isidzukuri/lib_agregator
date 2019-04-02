class Api::SearchController < ApplicationController
  def index
    if params[:word].present?
      books = find_books.select { |b| b.domain == 'chtyvo.org.ua' }
      render json: books, each_serializer: Api::BookInListSerializer
    end
  end

  def paper
    if params[:word].present?
      books = find_books.select { |b| !b.paper.nil? }
      render json: books, each_serializer: Api::BookInListSerializer
    end
  end

  private

  def find_books
    Book::SearchByTitleQuery.new(
      word: params[:word],
      limit: @per_page,
      offset: @offset
    ).call
  end
end
