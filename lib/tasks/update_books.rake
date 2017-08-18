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

  task remove_www_from_yakaboo: :environment do
    books = Book.where(domain: 'yakaboo.ua').select(:id, :paper).all
    books.each do |book|
      book.update_attribute(:paper, book.paper.gsub!("www.", ""))
    end
  end
end
