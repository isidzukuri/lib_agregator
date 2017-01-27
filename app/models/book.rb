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
    indexes :description
  end

  def self.search_by_title word
    search = Tire::Search::Search.new('books', load: true)
    search.query  { string("title:#{word}") }
    # p search.results
    ActiveRecord::Associations::Preloader.new.preload(search.results, :authors)
    search.results
  end

end
