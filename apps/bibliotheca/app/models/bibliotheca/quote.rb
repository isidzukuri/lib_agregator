module Bibliotheca
class Quote < ActiveRecord::Base
  self.table_name = 'quotes'
  
  belongs_to :user
  belongs_to :book

  validates :text, presence: true
end
end
