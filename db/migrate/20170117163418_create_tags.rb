class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string  :title
      t.string  :seo
    end
    add_index :tags, :seo, unique: true
  end
end
