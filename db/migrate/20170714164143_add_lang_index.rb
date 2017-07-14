class AddLangIndex < ActiveRecord::Migration[5.0]
  def change
    add_column(:books, :language, :string)
    
    QuessLanguage.set_uk
    add_index :books, :language
  end
end
