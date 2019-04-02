class Book < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include SeoName

  FORMATS = [:txt, :rtf, :doc, :pdf, :fb2, :epub, :mobi, :djvu, :paper] 
  VIEW_ATTRIBUTES = [:id, :title, :seo, :is_copy] + FORMATS

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

    pointers
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
    end

    result
  end

  def self.autocomplete_with_seo word, limit = 10
    like = "%#{word}%"
    items = Book.where("LOWER(title) LIKE :query OR seo LIKE :query", query: like)
              .limit(limit).includes(:authors)
  end

  def self.only_paper?(book)
    only_paper = true
    Book::FORMATS.each do |frmt|
      next if frmt == :paper
      if book[frmt]
        only_paper = false
        break
      end
    end
    only_paper
  end

  def self.thumb book
    book['optimized_cover'] ? "https://d6ezdopzv6g4b.cloudfront.net/#{book['optimized_cover']}" : book['cover']
  end

  def self.e_yakaboo
    where("domain = 'yakaboo.ua' AND ((`books`.`txt` IS NOT NULL) OR (`books`.`rtf` IS NOT NULL) OR (`books`.`doc` IS NOT NULL) OR (`books`.`pdf` IS NOT NULL) OR (`books`.`fb2` IS NOT NULL) OR (`books`.`epub` IS NOT NULL) OR (`books`.`mobi` IS NOT NULL) OR (`books`.`djvu` IS NOT NULL))").includes(:authors)
  end

  def thumb
    optimized_cover ? "https://d6ezdopzv6g4b.cloudfront.net/#{optimized_cover}" : cover
  end

  def author_title
    authors.present? ? authors[0].display_title : ''
  end

end
