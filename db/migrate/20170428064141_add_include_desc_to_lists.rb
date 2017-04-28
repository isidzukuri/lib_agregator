class AddIncludeDescToLists < ActiveRecord::Migration[5.0]
  def change
    add_column(:lists, :descriptions, :boolean, default: false)
  end
end
