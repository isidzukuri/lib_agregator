module Bibliotheca
class Tag < ActiveRecord::Base
  self.table_name = 'tags'
  
  include Concerns::SeoName

  has_and_belongs_to_many :books

  validates :title, presence: true
end
end
