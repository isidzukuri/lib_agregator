class Genre < ActiveRecord::Base
  include SeoName

  has_many :books

  validates :title, presence: true
end
