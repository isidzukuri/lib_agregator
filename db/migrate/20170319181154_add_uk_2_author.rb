class AddUk2Author < ActiveRecord::Migration[5.0]
  def change
    add_column(:authors, :uk, :string, null: true) 
  end
end
