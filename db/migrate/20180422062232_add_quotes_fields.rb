class AddQuotesFields < ActiveRecord::Migration[5.0]
  def change

    add_column(:quotes, :hide, :boolean)
    add_column(:quotes, :book_name, :string)
    add_column(:quotes, :author_name, :string)

  end
end
