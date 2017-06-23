class CreateRecomendations < ActiveRecord::Migration[5.0]
  def change
    create_table :recomendations do |t|
      t.integer :book_id
      t.integer :order, default: 999
    end

    drop_table :recomended
      
  end
end
