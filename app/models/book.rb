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

  def read_also limit
    items = []
    return items unless tags
    tags_ids = tags.map(&:id)#.join(',')
    rows = BooksTag.where(tag_id: tags_ids).includes(:book).where.not(books: {cover: nil}).order('RAND()').limit(limit)
    items = rows.map(&:book)
    items
  end

end
