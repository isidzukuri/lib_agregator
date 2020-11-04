class CreateBookTags < ActiveRecord::Migration[4.2]
  def change
    create_table :books_tags do |t|
      t.references :tag, :null => false
      t.references :book, :null => false
    end
    add_index :books_tags, [:tag_id, :book_id], unique: true
  end
end
