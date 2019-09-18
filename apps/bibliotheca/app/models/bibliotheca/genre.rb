module Bibliotheca
class Genre < ActiveRecord::Base
  self.table_name = 'genres'
  
  include Concerns::SeoName

  has_many :books

  validates :title, presence: true
end
end
