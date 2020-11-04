class CreateTags < ActiveRecord::Migration[4.2]
  def change
    create_table :tags do |t|
      t.string  :title
      t.string  :seo
    end
    add_index :tags, :seo, unique: true
  end
end
