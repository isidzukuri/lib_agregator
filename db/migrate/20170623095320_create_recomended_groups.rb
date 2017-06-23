class CreateRecomendedGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :recomended do |t|
      t.integer :book_id
      t.integer :order, default: 999
    end


  end
end
