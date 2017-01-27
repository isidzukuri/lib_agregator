class BooksController < ApplicationController

  def show
    @book = Book.includes(:authors, :tags, :genre).find_by_seo(params[:key])
  end

end