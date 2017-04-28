class List < ActiveRecord::Base
  include SeoName
  belongs_to :user
  has_and_belongs_to_many :books

  mount_uploader :cover, CoverUploader

  validates :title, presence: true

  def thumb
    cover ? cover.thumb.url : nil
  end
end
