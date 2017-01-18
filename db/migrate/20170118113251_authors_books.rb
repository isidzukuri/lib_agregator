class AuthorsBooks < ActiveRecord::Migration
  def change
    create_table :authors_books do |t|
      t.references :author, :null => false
      t.references :book, :null => false
    end
    add_index :authors_books, [:author_id, :book_id], unique: true
  end
end
