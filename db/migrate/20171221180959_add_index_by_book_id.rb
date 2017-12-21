class AddIndexByBookId < ActiveRecord::Migration[5.0]
  def change
    remove_index(:authors_books, :name => :index_authors_books_on_author_id_and_book_id)
    add_index :authors_books, :book_id
    add_index :authors_books, :author_id

  end
end
