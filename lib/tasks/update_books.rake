namespace :update_books do
  desc 'TODO'
  task chtyvo_epub: :environment do
    data = JSON.parse open('public/data_2017_01_17.json').read
    data.each do |entry|
      next if entry['epub'].nil?
      book = Book.find_by_source(entry['source'])
      book.epub = "http://chtyvo.org.ua#{entry['epub']}"
      book.save
    end
  end
end
