class SearchController < ApplicationController

  def index
    if params[:word].present?
      @books = Book.search_by_title(params[:word])
      @authors = Author.search_by_full_name(params[:word])


      # ap @books.first.authors
    else
      # redirect somewhere
    end


  end

end