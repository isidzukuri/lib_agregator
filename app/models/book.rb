class Book < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include SeoName

  has_and_belongs_to_many :authors
  has_and_belongs_to_many :tags
  belongs_to :genre

  validates :title, presence: true

  mapping do
    indexes :title
    indexes :seo
    indexes :description
  end

  def self.search_by_title(word, limit = 100, offset = 0)
    search = Tire::Search::Search.new('books', load: true)
    search.query { string("title:#{word}") }
    # p '@'*88
    # p search.results
    # p '@'*88
    pointers = search.results
    pointers = pointers.drop(offset) if offset > 0
    pointers = pointers.first(limit)

    ActiveRecord::Associations::Preloader.new.preload(pointers, :authors)

    pointers#.reverse # .uniq { |i| [i.title, i.domain, i.description] } # remove old duplicates from yakaboo
  end

  def self.extended_search(params, limit = 100, offset = 0)
    result = []

    search = Tire::Search::Search.new('books')
    search.query { string("title:#{params[:word]}") }

    ids = search.results.pluck(:id)

    if ids.present?
      query = where(id: ids)
      query = query.where(genre_id: params[:genre]) if params[:genre]

      if params[:format]
        formats = []
        params[:format].each do |frmt|
          formats << "`#{frmt}` IS NOT NULL"
        end
        frmt_condition = formats.join(' OR ')
        query = query.where(frmt_condition)
      end

      cols = attribute_names - %w(description source domain genre_id)
      result = query.select(cols).includes(:authors).limit(limit).offset(offset).all

      # result = query.includes(:authors)
      #         .limit(limit).offset(offset)
      #         .all.reverse.uniq { |i| [i.title, i.domain, i.description] }
    end

    result
  end

  def self.autocomplete_with_seo word, limit = 10
    like = "%#{word}%"
    items = Book.where("LOWER(title) LIKE :query OR seo LIKE :query", query: like)
              .limit(limit).includes(:authors)
  end

  def author_title
    authors.present? ? authors[0].display_title : ''
  end

  def only_paper?
    only_paper = true
    $book_formats.each do |frmt|
      next if frmt == 'paper'
      if send(frmt.to_sym)
        only_paper = false
        break
      end
    end
    only_paper
  end

  def self.read_also book, tags_ids, language, limit
    items = []
    return items unless tags_ids
    random_id = rand(1..book['id'].to_i)
    
    where = "books_tags.tag_id IN(#{tags_ids.join(',')}) AND 
            books.optimized_cover IS NOT NULL AND
            books.id > #{random_id}
            "
    where += "AND books.language = '#{language}'" if language.present?

    sql = "SELECT
            books.id, 
            books.title, 
            books.seo, 
            books.optimized_cover
          FROM books_tags
          INNER JOIN books ON books_tags.book_id = books.id
          WHERE 
            #{where}
          LIMIT #{limit} 
    "
    ActiveRecord::Base.connection.exec_query(sql).to_hash
  end
  # def read_also limit
  #   items = []
  #   return items unless tags
      
  #   random_id = rand(1..id)
  #   tags_ids = tags.map(&:id)#.join(',')
  #   rows = BooksTag.where(tag_id: tags_ids)
  #         .includes(:book)
  #         .where(books:{language: language})
  #         .where("books.id > ?", random_id)
  #         .where.not(books: {cover: nil})
  #         .limit(limit)
  #   items = rows.map(&:book)
  #   items
  # end

  def self.all_data seo
    sql = "SELECT 
            books.*, 
            genres.title as genre_title, 
            genres.seo as genre_seo, 
            GROUP_CONCAT(DISTINCT authors_books.author_id SEPARATOR ',') as authors_ids,
            GROUP_CONCAT(DISTINCT books_tags.tag_id SEPARATOR ',') as tags_ids
          FROM books
          LEFT JOIN genres ON genres.id = books.genre_id
          LEFT JOIN authors_books ON authors_books.book_id = books.id
          LEFT JOIN books_tags ON books_tags.book_id = books.id
          WHERE books.seo = '#{seo}'
          GROUP BY books.id"
    data = ActiveRecord::Base.connection.exec_query(sql).to_hash[0]
    tags_data, authors_data = []
    if data
      tags_data = Tag.where(id: data['tags_ids'].split(',')).to_a if data['tags_ids'].present?
      authors_data = Author.where(id: data['authors_ids'].split(',')).to_a if data['authors_ids'].present?
    end
    return data, tags_data || [], authors_data || []
  end

  def thumb
    # optimized_cover ? "/covers/#{optimized_cover}" : cover
    optimized_cover ? "https://d6ezdopzv6g4b.cloudfront.net/#{optimized_cover}" : cover
  end

  def self.thumb book
    # optimized_cover ? "/covers/#{optimized_cover}" : cover
    book['optimized_cover'] ? "https://d6ezdopzv6g4b.cloudfront.net/#{book['optimized_cover']}" : book['cover']
  end

  def self.e_yakaboo
    where("domain = 'yakaboo.ua' AND ((`books`.`txt` IS NOT NULL) OR (`books`.`rtf` IS NOT NULL) OR (`books`.`doc` IS NOT NULL) OR (`books`.`pdf` IS NOT NULL) OR (`books`.`fb2` IS NOT NULL) OR (`books`.`epub` IS NOT NULL) OR (`books`.`mobi` IS NOT NULL) OR (`books`.`djvu` IS NOT NULL))").includes(:authors)
  end

end
