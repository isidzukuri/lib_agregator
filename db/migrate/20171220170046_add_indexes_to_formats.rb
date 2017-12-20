class AddIndexesToFormats < ActiveRecord::Migration[5.0]
  def change
    ['txt', 'rtf', 'doc', 'pdf', 'fb2', 'epub', 'mobi', 'djvu', 'paper'].each do |frmt|
      add_index :books, frmt.to_sym
    end
     

  end
end
