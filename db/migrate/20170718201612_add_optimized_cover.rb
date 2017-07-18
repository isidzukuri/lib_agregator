class AddOptimizedCover < ActiveRecord::Migration[5.0]
  def change
    add_column(:books, :optimized_cover, :string)
  end
end
