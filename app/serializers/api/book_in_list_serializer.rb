class BookInListSerializer < ActiveModel::Serializer
  attributes :id, :name, :seo, :link

  def link
    object.respond_to?(:link) ? object.link : nil  
  end
end
