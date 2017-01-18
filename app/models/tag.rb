class Tag < ActiveRecord::Base
  include SeoName

  has_and_belongs_to_many :books

  validates :title, presence: true
end
