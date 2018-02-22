class AddIsCopyIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :books, :is_copy
  end
end
