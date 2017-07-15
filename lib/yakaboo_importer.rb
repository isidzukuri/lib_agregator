class YakabooImporter
  attr_accessor :data, :authors, :genres, :tags

  def initialize
    ActiveRecord::Base.logger.level = 1
    @authors = {}
    @genres = {}
    @tags = {}
    $updated = []
    $skiped = 0
  end

  def import
    doc = Nokogiri::XML.parse(open('public/sd-feed-269.xml').read)
    skip = Book.where(domain: 'yakaboo.ua').pluck(:paper)

    # ap doc.xpath("//offers/offer").first
    entries = doc.xpath('//offers/offer')
    total = entries.count
    entries.each_with_index do |el, i|
      ap "#{i+1}/#{total}"
      b_data = Hash.from_xml(el.to_s)['offer']
      next if b_data['type'] != 'book'
      if skip.delete(b_data['url'])
        $skiped += 1
        ap '-skiped'
        next
      end

      # categories_path = b_data['category_path'].split(' > ')
      # catecory_str = categories_path[1]

      b_data['param'].delete('Книги')
      tags_arr = b_data['param']

      b_authors = []
      if b_data['author']
        b_data['author'].split(',').each do |author|
          b_authors << book_author(author)
        end
      end

      next if update_item(b_data, b_authors)

      b_tags = []
      if tags_arr.present?
        tags_arr.each do |tag|
          b_tags << book_tag(tag.mb_chars.downcase.to_s)
        end
      end

      result = {
        'title' => b_data['name'],
        'description' => clear_description(b_data['description']),
        'cover' => b_data['picture'],
        'authors' => b_authors.uniq,
        'genre' => book_genre,
        'tags' => b_tags.uniq,
        'paper' => b_data['url'],
        'source' => 'xml',
        'domain' => 'yakaboo.ua',
        'language' => language?(b_data)
      }
      # ap result
      begin
        Book.create(result)
      rescue
      end
    end

    true
  end

  def landuage?(b_data)
    lang = nil
    lang = 'uk' if QuessLanguage.is_uk?(b_data['title']) || QuessLanguage.is_uk?(b_data['description'])
    lang
  end

  def clear_description str
    return '' if str.nil?
    str.sub!('От издателя:', '')
    str.sub!('От Yakaboo:', '')
  end

  def book_genre
    @genre ||= Genre.find_or_create_by(title: 'Паперові книги')
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
      author = Author.where("full_name = #{Author.sanitize(full_name)} OR uk = #{Author.sanitize(full_name)} ").first
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

  def update_item b_data, authors
    result = false
    authors_ids = authors.map(&:id).join(',')
    query = Book.where(title: b_data['name'])
    query = query.joins(:authors).where("authors_books.author_id in(#{authors_ids})") if authors.present?

    entry = query.first
    return result unless entry

    diff = entry.authors.ids - authors.map(&:id)
    if diff.empty?
      entry.update_attribute(:paper, b_data['url'])
      $updated << entry
      result = true
      ap "- updated"
    end
    result
  end

end
