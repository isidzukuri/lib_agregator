class Article < ActiveRecord::Base
  include SeoName
  belongs_to :user

  validates :title, presence: true
end
