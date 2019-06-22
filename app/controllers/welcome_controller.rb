class WelcomeController < ApplicationController
  caches_action :index, expires_in: 12.hour

  def index
    content = Content::HomePage.new
    @paper_books = content.paper_books
    @free_books = content.free_books
    @lists = content.lists
    @articles = content.articles
  end
end
