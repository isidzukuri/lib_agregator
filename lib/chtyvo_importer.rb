class ChtyvoImporter
  attr_accessor :data, :authors, :genres, :tags

  def initialize
    # ActiveRecord::Base.logger.level = 1
    @authors = {}
    @genres = {}
    @tags = {}
  end

  def import
    @data = JSON.parse open('public/Chtyvo/data_2017_06_23.json').read

    data.each_with_index do |entry, i|
      begin
        ap i
        author = [book_author(entry['author'])]
        genre = book_genre(entry['category'])
        tags = [book_tag(entry['tags'])]

        # skip allready existing books
        # new json - old json
        create_book(entry, author, genre, tags)
      rescue
        ap "error"
      end
    end

    true
  end

  def create_book(entry, authors, genre, tags)
    entry.delete('author')
    entry.delete('tags')
    entry.delete('category')


    entry['epub'] = entry['ebup']
    entry.delete('ebup')
    entry['authors'] = authors
    entry['genre'] = genre
    entry['tags'] = tags
    entry['cover'] = "http://chtyvo.org.ua#{entry['cover']}" if entry['cover'].present?

    %w(txt rtf doc pdf fb2 epub mobi djvu).each do |frmt|
      entry[frmt] = "http://chtyvo.org.ua#{entry[frmt]}" if entry[frmt].present?
    end

    Book.create(entry)
  end

  def book_author(full_name)
    full_name = full_name.strip
    author = find_author(full_name)
    unless author.present?
      names = full_name.split(' ')
      author = Author.create(
        full_name: full_name,
        last_name: names[1],
        first_name: names[0]
      )
    end
    author
  end

  def find_author(full_name)
    author = authors[full_name]
    unless author
      # author = Author.find_by_full_name(full_name)
      author = Author.where("full_name = '#{full_name}' OR uk = '#{full_name}' ").first
      authors[full_name] = author
    end
    author
  end

  def book_tag(title)
    title = title.strip
    tag = find_tag(title)
    tag = Tag.create(title: title) unless tag.present?
    tag
   end

  def find_tag(title)
    title = title.strip
    tag = tags[title]
    unless tag
      tag = Tag.find_by_title(title)
      tags[title] = tag
    end
    tag
  end

  def book_genre(title)
    title = title.strip
    genre = find_genre(title)
    genre = Genre.create(title: title) unless genre.present?
    genre
  end

  def find_genre(title)
    genre = genres[title]
    unless genre
      genre = Genre.find_by_title(title)
      genres[title] = genre
    end
    genre
  end
end
