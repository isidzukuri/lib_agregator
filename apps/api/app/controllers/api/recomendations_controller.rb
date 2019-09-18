module Api
  class RecomendationsController < ApplicationController
    def paper
      ids = Bibliotheca::Recomendation.pluck(:book_id)
      books = Bibliotheca::Book.includes(:authors).where(id: ids).
                                            select(:id, :title, :cover, :source, :paper, :domain, :optimized_cover).
                                            order(id: :desc)

      render json: books, each_serializer: Api::BookInListSerializer
    end
  end
end
