class YakabooWebImporter
  attr_accessor :data, :authors, :genres, :tags

 def initialize
    # ActiveRecord::Base.logger.level = 1
    @authors = {}
    @genres = {}
    @tags = {}
    $updated = []
    $skiped = 0
  end

  def import
    entries = JSON.parse open('public/Yakaboo/data_2018_05_29.json').read
    
    total = entries.length
    entries.each_with_index do |b_data, i|
      ap "#{i+1}/#{total}"
      tags_arr = b_data['categories']
     

      b_authors = []
      b_authors << book_author(b_data['author']) if b_data['author']

      frmts = {}
      ['txt', 'rtf', 'doc', 'pdf', 'fb2', 'epub', 'mobi', 'djvu'].each do |frmt|
        frmts[frmt] = "https://rdr.salesdoubler.com.ua/in/offer/269?aid=20647&dlink=#{b_data[frmt]}" if b_data[frmt].present?
      end
      
      next if update_item(b_data, b_authors, frmts)

      b_tags = []
      if tags_arr.present?
        tags_arr.each do |tag|
          b_tags << book_tag(tag)
        end
      end



      result = {
        'title' => b_data['title'],
        'description' => b_data['description'],
        'cover' => b_data['picture'],
        'authors' => b_authors.uniq,
        'tags' => b_tags.uniq,
        'source' => 'yakaboo.ua',
        'domain' => 'yakaboo.ua',
        'language' => language?(b_data)
      }
      result.merge!(frmts)
      # ap result
      # next
      begin
        book = Book.create(result)
      rescue
      end
      optimize_image(book)
    end

    true
  end

  def optimize_image book
    return unless book.cover.present?
    ext = book.cover.split('.').last
    image = MiniMagick::Image.open(book.cover)
    image.resize "280x350\>"
    filename = "#{book.id}.#{ext}"
    image.write("public/covers/#{filename}")
    `mogrify -quality 80 public/covers/#{filename}`
    book.update_attribute(:optimized_cover, filename)
  end

  def language?(b_data)
    lang = nil
    lang = 'uk' if QuessLanguage.is_uk?(b_data['title']) || QuessLanguage.is_uk?(b_data['description'])
    lang
  end

  def clear_description str
    return '' if str.nil?
    str.sub!('От издателя:', '')
    str.sub!('От Yakaboo:', '')
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

  def update_item b_data, authors, frmts
    result = false
    authors_ids = authors.map(&:id).join(',')
    query = Book.where(title: b_data['title'])
    query = query.joins(:authors).where("authors_books.author_id in(#{authors_ids})") if authors.present?

    entry = query.first
    return result unless entry

    diff = entry.authors.ids - authors.map(&:id)
    if diff.empty?
      entry.update_attributes(frmts)
      $updated << entry
      result = true
      ap "- updated"
    end
    result
  end

  
end
