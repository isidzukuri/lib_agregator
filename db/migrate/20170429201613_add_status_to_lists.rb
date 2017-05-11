class AddStatusToLists < ActiveRecord::Migration[5.0]
  def change
    add_column(:lists, :status, :string, default: 'unpublished')
    add_index :lists, :status
    add_index :articles, :status
  end
end
