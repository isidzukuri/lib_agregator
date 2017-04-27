class List < ActiveRecord::Base
  include SeoName
  belongs_to :user
  has_and_belongs_to_many :books

  validates :title, presence: true
end
