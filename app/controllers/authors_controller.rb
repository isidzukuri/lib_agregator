class AuthorsController < ApplicationController
  def index
    @items = Author.order(:full_name).limit(@per_page).offset(@offset).all
    @items_total = Author.count
  end

  def show
    @author = Author.find_by_seo(params[:key])
    @items = @author.books.limit(@per_page).offset(@offset)
    @items_total = @author.books.count
  end
end
