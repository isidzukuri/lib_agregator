class Book < ActiveRecord::Base
  include SeoName

  has_and_belongs_to_many :authors
  has_and_belongs_to_many :tags
  belongs_to :genre

  validates :title, presence: true


end
