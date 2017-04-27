class CreateLists < ActiveRecord::Migration[5.0]
  def change
    create_table :lists do |t|
      t.string  :title, index: true
      t.text    :description
      t.string  :cover
      t.string  :seo
      t.integer :user_id, index: true
    end
    add_index :lists, :seo, unique: true


    create_table :books_lists do |t|
      t.references :list, :null => false
      t.references :book, :null => false
    end
    add_index :books_lists, [:list_id, :book_id], unique: true
  end
end
