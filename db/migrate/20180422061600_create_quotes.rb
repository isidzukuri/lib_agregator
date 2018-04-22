class CreateQuotes < ActiveRecord::Migration[5.0]
  def change
    create_table :quotes do |t|
      t.text    :text
      t.integer :user_id, index: true
      t.integer :book_id, index: true

      t.timestamps null: false
    end
  end
end
