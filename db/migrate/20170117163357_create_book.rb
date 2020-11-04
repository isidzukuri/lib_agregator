class CreateBook < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string  :title, index: true
      t.text    :description
      t.string  :cover
      t.string  :domain, index: true
      t.string  :source, index: true

      t.string  :paper, limit: 500
      t.string  :txt
      t.string  :rtf
      t.string  :doc
      t.string  :pdf
      t.string  :fb2
      t.string  :ebup
      t.string  :mobi
      t.string  :djvu

      t.integer :genre_id, index: true

      t.string  :seo
    end
    add_index :books, :seo, unique: true
  end
end