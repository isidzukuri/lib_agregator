class ImproveData

  def initialize
    ActiveRecord::Base.logger.level = 1
  end

  def books
    books = Book.select(:id, :title).where(domain: 'yakaboo.ua').includes(:authors)

    total = books.length
    books.each_with_index do |book, i|
      ap "#{i+1}/#{total}"
      next unless Book.exists?(book.id)
      same = find_same_book(book)
      if same.present?
        same.map(&:destroy) 
        ap book.title
      end
    end
  end

  def find_same_book book
    result = []
    authors_ids = book.authors.ids.join(',')

    query = Book.where(title: book.title, domain: 'yakaboo.ua').where.not(id: book.id)
    query = query.joins(:authors).where("authors_books.author_id in(#{authors_ids})") if authors_ids.present?
    entries = query
    return result unless entries

    entries.each do |entry|
      diff = entry.authors.ids - book.authors.ids
      result << entry if diff.empty?
    end
    result
  end

  def authors

    all_authors = Author.all
    total = all_authors.length

    all_authors.each_with_index do |author, i|
      ap "#{i+1}/#{total}"

      next if author.uk != author.full_name
      # next unless Author.exists?(author.id)
      same = Author.where(uk: author.full_name).where.not(id: author.id).first
      next unless same

      sql = "UPDATE authors_books SET author_id = #{same.id} WHERE author_id = #{author.id}"
      records_array = ActiveRecord::Base.connection.execute(sql)

      author.destroy
    end
  end


end
