class YakabooImporter

	attr_accessor :data, :authors, :genres, :tags
  
  def initialize
    @authors = {}
   	@genres = {}
   	@tags = {}
  end
	
	def import
    doc = Nokogiri::XML.parse(open('public/sd-feed-269.xml').read)
    skip = Book.where(domain: 'yakaboo.ua').pluck(:paper)

    # ap doc.xpath("//offers/offer").first

    doc.xpath("//offers/offer").each do |el|
      b_data = Hash.from_xml(el.to_s)["offer"]
      next if b_data['type'] != "book"
      next if skip.delete(b_data['url']) 



      categories_path = b_data['category_path'].split(' > ')
      catecory_str = categories_path[1]

      b_data['param'].delete("Книги")
      tags_arr = b_data['param']


      authors = []
      if b_data['author']
        b_data['author'].split(',').each do |author|
           authors << book_author(author)
        end
      end

      tags = []
      if tags_arr.present?
        tags_arr.each do |tag|
           tags << book_tag(tag.mb_chars.downcase.to_s)
        end
      end

      result = {
        'title' => b_data['name'],
        'description' => b_data['description'],
        'cover' => b_data['picture'],
        'authors' => authors.uniq,
        # 'genre' => book_genre(catecory_str.downcase.to_s),
        'tags' => tags.uniq,
        'paper' => b_data['url'],
        'source' => 'xml',
        'domain' => 'yakaboo.ua'
      }
      ap result

      Book.create(result)
      # 

    end

    true
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

