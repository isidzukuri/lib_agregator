class AddIsCopyToBook < ActiveRecord::Migration[5.0]
  def change
    add_column(:books, :is_copy, :boolean, default: false, null: false)
  end
end
