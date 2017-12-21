class BetterIndexStructure < ActiveRecord::Migration[5.0]
  def change
    remove_index(:books_tags, :name => :index_books_tags_on_tag_id_and_book_id)
    add_index :books_tags, :book_id
    add_index :books_tags, :tag_id

  end
end
