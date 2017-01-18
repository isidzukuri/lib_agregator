class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string  :full_name, index: true
      t.string  :last_name, index: true
      t.string  :first_name
      t.string  :seo
    end
    add_index :authors, :seo, unique: true
  end
end
