class ExtendedSearchController < ApplicationController
  def new
    @genres = Genre.all
  end

  def show
    redirect_to :root unless params[:word].present?

    @books = Book::ExtendedSearchQuery.new(params).call
  end
end
