class AddHide < ActiveRecord::Migration[5.0]
  def change
    add_column(:books, :hide, :boolean)
    add_column(:authors, :hide, :boolean)
  end
end
