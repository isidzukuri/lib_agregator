class MarkBookAsCopy
  

  def initialize
    ActiveRecord::Base.logger.level = 1
  end

  def call
    books = Book.where(domain: 'chtyvo.org.ua').includes(:authors)

    skip = []

    total = books.length
    books.each_with_index do |book, i|
      ap "#{i+1}/#{total}"
      # next unless Book.exists?(book.id)
      next if skip.include?(book.id)
      same = find_same_book(book)
      if same.present? 
        same_ids = same.map(&:id)
        skip += same_ids
        Book.where(id: same_ids).update_all(is_copy: true)
        # ap book.title
        # ap same.count
        # ap same.map(&:id)
      end
    end
    skip.count
  end

  def find_same_book book
    result = []
    authors_ids = book.authors.ids.join(',')

    query = Book.where(title: book.title, domain: 'chtyvo.org.ua').where.not(id: book.id)
    query = query.joins(:authors).where("authors_books.author_id in(#{authors_ids})") if authors_ids.present?
    entries = query
    return result unless entries

    entries.each do |entry|
      diff = entry.authors.ids - book.authors.ids

      same_formats = true
      $book_formats.each do |f|
        same_formats = book[f] == entry[f]
        break unless same_formats
      end

      result << entry if diff.empty? && same_formats
    end
    result

  end

 

end
