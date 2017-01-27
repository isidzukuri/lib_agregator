class SearchController < ApplicationController

  def index
    if params[:word].present?
      @books = Book.includes(:authors).search_by_title(params[:word])

      # ap @books.first.authors
    else
      # redirect somewhere
    end


  end

end