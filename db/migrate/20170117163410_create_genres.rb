class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string  :title
      t.string  :seo
    end
    add_index :genres, :seo, unique: true
  end
end
