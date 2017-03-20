class AddUk2Tag < ActiveRecord::Migration[5.0]
  def change
    add_column(:tags, :uk, :string)
  end
end
