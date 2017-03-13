class Api::SearchController < ApplicationController

  def index
    if params[:word].present?
      # @books = Book.search_by_title(params[:word], @per_page, @offset)
      @books = [Book.last]
      render json: @books
    end

  end

end