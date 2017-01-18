class Author < ActiveRecord::Base
  include SeoName

  has_and_belongs_to_many :books

  validates :full_name, presence: true

  def seo_source
    :full_name
  end
end
