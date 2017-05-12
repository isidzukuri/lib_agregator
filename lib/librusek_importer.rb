class LibrusekImporter
  attr_accessor :data, :authors, :genres, :tags

  def initialize
    ActiveRecord::Base.logger.level = 1
    @authors = {}
    @genres = {}
    @tags = {}
    @data = JSON.parse open('public/Librusek/data_2017_03_28.json').read
  end

  # translate tags
  # translate authors


  def import
    data.each do |entry|
      # begin
        next if Book.find_by_title(entry['title'])
        author = [book_author(entry['author'])]

        tags = []
        tags_arr = entry['tags']
        if tags_arr.present?
          tags_arr.each do |tag|
            tags << book_tag(tag.mb_chars.downcase.to_s)
          end
        end

        create_book(entry, author, tags)
      # rescue
      # end
    end

    true
  end

  def create_book(entry, authors,  tags)
    entry.delete('author')
    entry.delete('tags')
    entry.delete('category')

    entry['authors'] = authors
    entry['tags'] = tags

    %w(txt rtf doc pdf fb2 epub mobi djvu).each do |frmt|
      entry[frmt] = entry[frmt] if entry[frmt].present?
    end

    # ap entry
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


  
  def stats
    stats_categories = {}
    exists = 0

    data.each do |item|
      if stats_categories[item['category']].nil?
        stats_categories[item['category']] = 1 
      else
        stats_categories[item['category']] += 1
      end
      stored_book = Book.find_by_title(item['title'])
      if stored_book
        exists += 1
        ap "#{stored_book.author_title} == #{item['author']}"
      end

    end

    ap data.first
    ap stats_categories
    ap data.count
    ap "exists: #{exists}"
  end

  
end
