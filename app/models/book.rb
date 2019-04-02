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

  def self.autocomplete_with_seo word, limit = 10
    like = "%#{word}%"
    items = Book.where("LOWER(title) LIKE :query OR seo LIKE :query", query: like)
              .limit(limit).includes(:authors)
  end

  def self.thumb book
    book['optimized_cover'] ? "#{CloudFront::URL}#{book['optimized_cover']}" : book['cover']
  end

  def thumb
    optimized_cover ? "#{CloudFront::URL}#{optimized_cover}" : cover
  end

  def author_title
    authors.present? ? authors[0].display_title : ''
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
end
