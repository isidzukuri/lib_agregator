module Bibliotheca
class List < ActiveRecord::Base
  self.table_name = 'lists'

  include Concerns::SeoName
  belongs_to :user
  has_and_belongs_to_many :books

  mount_uploader :cover, CoverUploader

  validates :title, presence: true

  def thumb
    cover ? cover.thumb.url : nil
  end

end
end
