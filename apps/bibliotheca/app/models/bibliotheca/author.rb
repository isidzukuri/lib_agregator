module Bibliotheca
class Author < ActiveRecord::Base
  self.table_name = 'authors'

  include Tire::Model::Search
  include Tire::Model::Callbacks
  include SeoName

  has_and_belongs_to_many :books

  validates :full_name, presence: true

  alias_attribute :title, :full_name

  mapping do
    indexes :full_name
    indexes :uk
  end

  def self.search_by_full_name(word)
    search = Tire::Search::Search.new('authors', load: true)
    search.query { string("full_name:#{word} OR uk:#{word}") }
    search.results
  end

  def seo_source
    :full_name
  end

  def display_title
    uk.present? ? uk : title
  end
end
end
