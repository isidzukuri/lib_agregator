class Author < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include SeoName

  has_and_belongs_to_many :books

  validates :full_name, presence: true

  mapping do
    indexes :full_name
  end

  def seo_source
    :full_name
  end
end
