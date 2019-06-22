class Book < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include SeoName

  FORMATS = [:txt, :rtf, :doc, :pdf, :fb2, :epub, :mobi, :djvu, :paper].freeze
  VIEW_ATTRIBUTES = [:id, :title, :seo, :is_copy] + FORMATS
  DOMAINS = { chtyvo: 'chtyvo.org.ua',
              librusec: 'lib.rus.ec',
              yakaboo: 'yakaboo.ua' }.freeze

  has_and_belongs_to_many :authors
  has_and_belongs_to_many :tags
  belongs_to :genre

  validates :title, presence: true

  mapping do
    indexes :title
    indexes :seo
    indexes :description
  end

  def self.thumb(book)
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
