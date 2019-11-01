# frozen_string_literal: true
require 'csv'
module BooksMining
  class ChtyvoImporter
    STORE_PATH = 'tmp/chtyvo.org.ua/store/*'

    attr_accessor :data, :authors, :genres, :tags, :errors

    def initialize
      # ActiveRecord::Base.logger.level = 1
      @authors = {}
      @genres = {}
      @tags = {}
      @errors = []
    end

    def path_to_store
      files_sorted_by_time = Dir[STORE_PATH].sort_by { |f| File.mtime(f) }
      files_sorted_by_time[(files_sorted_by_time.length - 1)]
    end

    def call
      CSV.foreach(path_to_store, {headers: true}) do |entry|
        entry = entry.to_h
        # ap entry
        begin
          author = [book_author(entry['author'])]
          genre = book_genre(entry['category'])
          tags = [book_tag(entry['tags'])]

          create_book(entry, author, genre, tags)
        rescue => e
          ap e.message
          errors << e.message
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
      entry['language'] = 'uk'
      entry['cover'] = entry['cover'] if entry['cover'].present?

      %w(txt rtf doc pdf fb2 epub mobi djvu).each do |frmt|
        entry[frmt] = "http://chtyvo.org.ua#{entry[frmt]}" if entry[frmt].present?
      end

      return if book_present?(entry, authors)

      book = Book.create(entry)
      optimize_image(book)

      book
    end

    def book_author(full_name)
      full_name = full_name.strip
      author = find_author(full_name)
      unless author.present?
        names = full_name.split(' ')
        author = Author.create(
          full_name: full_name[0..200],
          last_name: names[1],
          first_name: names[0]
        )
      end
      author
    end

    def find_author(full_name)
      author = authors[full_name]
      unless author
        author = Author.where("full_name = :full_name OR uk = :full_name ", {full_name: full_name}).first
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

    def optimize_image book
      begin
        return unless book.cover.present?
        ext = book.cover.split('.').last
        image = MiniMagick::Image.open(book.cover)
        image.resize "280x350\>"
        filename = "#{book.id}.#{ext}"
        image.write("public/covers/#{filename}")
        `mogrify -quality 80 public/covers/#{filename}`
        book.update_attribute(:optimized_cover, filename)
      rescue
        p 'optimize_image error'
      end
    end

    def book_present? b_data, authors
      result = false
      authors_ids = authors.map(&:id).join(',')
      query = Book.where(domain: 'chtyvo.org.ua', title: b_data['title'])
      query = query.joins(:authors).where("authors_books.author_id in(#{authors_ids})") if authors_ids.present?

      !!query.first
    end
  end
end
