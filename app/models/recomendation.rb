class Recomendation < ActiveRecord::Base
  validates :book_id, presence: true
end
