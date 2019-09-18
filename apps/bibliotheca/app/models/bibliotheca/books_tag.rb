module Bibliotheca
class BooksTag < ActiveRecord::Base
  self.table_name = 'books_tags'

  belongs_to :book
  belongs_to :tag

end
end
