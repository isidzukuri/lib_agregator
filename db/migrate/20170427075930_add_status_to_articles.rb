class AddStatusToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column(:articles, :status, :string, default: 'published')
  end
end
