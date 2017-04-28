class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string  :title, index: true
      t.text    :description
      t.text    :text
      t.string  :cover
      t.string  :seo
      t.integer :user_id
    end
    add_index :articles, :seo, unique: true
  end
end
