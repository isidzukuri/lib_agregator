class Article < ActiveRecord::Base
  include SeoName
  belongs_to :user

  mount_uploader :cover, CoverUploader

  validates :title, presence: true

  def thumb
    cover ? cover.thumb.url : nil
  end
end
