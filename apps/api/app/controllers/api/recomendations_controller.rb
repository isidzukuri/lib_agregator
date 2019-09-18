module Api
  class RecomendationsController < ApplicationController
    def paper
      ids = Recomendation.pluck(:book_id)
      books = Book.includes(:authors).where(id: ids).select(:id, :title, :cover, :source, :paper).order(id: :desc)
      render json: books, each_serializer: Api::BookInListSerializer
    end
  end
end
