module Bibliotheca
class Recomendation < ActiveRecord::Base
  self.table_name = 'recomendations'

  validates :book_id, presence: true
end
end
