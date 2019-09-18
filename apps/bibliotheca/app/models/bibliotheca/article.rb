module Bibliotheca
class Article < ActiveRecord::Base
  self.table_name = 'articles'

  include SeoName
  belongs_to :user

  mount_uploader :cover, ArticleCoverUploader

  validates :title, presence: true

  def thumb
    cover ? cover.thumb.url : nil
  end

  def poster
    cover ? cover.poster.url : nil
  end
end
end
