class ChtyvoImporter

	attr_accessor :data, :authors, :genres, :tags
  
  def initialize
    @authors = {}
   	@genres = {}
   	@tags = {}
  end
	
	def import
		# take all parsed urls from db by domain
		# build sitemap
		# sitemap - existed urls
		# parse

		@data = JSON.parse open('public/data_2017_01_17.json').read

		data.each do |entry|
		author = [book_author(entry['author'])]
		genre = book_genre(entry['category'])
		tags = [book_tag(entry['tags'])]
		
		create_book(entry, author, genre, tags)
		end
		
		true
	end


	def create_book entry, authors, genre, tags
		entry.delete('author')
		entry.delete('tags')
		entry.delete('category')

		entry['authors'] = authors
		entry['genre'] = genre
		entry['tags'] = tags

		Book.create(entry)
	end

	def book_author full_name
		full_name = full_name.strip
		author = find_author(full_name)
		if !author.present?
			names = full_name.split(' ')
			author = Author.create(
				full_name: full_name,
				last_name: names[1],
				first_name: names[0] 
			)
		end
		author
	end

	def find_author full_name
    author = authors[full_name]
    if !author
      author = Author.find_by_full_name(full_name)
      authors[full_name] = author
    end
    author
  end

  def book_tag title
		title = title.strip
		tag = find_tag(title)
		if !tag.present?
			tag = Tag.create(title: title)
		end
		tag
	end

  def find_tag title
    title = title.strip
    tag = tags[title]
    if !tag
      tag = Tag.find_by_title(title)
      tags[title] = tag
    end
    tag
  end

	def book_genre title
		title = title.strip
		genre = find_genre(title)
		if !genre.present?
			genre = Genre.create(title: title)
		end
		genre
	end

  def find_genre title
    genre = genres[title]
    if !genre
      genre = Genre.find_by_title(title)
      genres[title] = genre
    end
    genre
  end
end

