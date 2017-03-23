class Api::BookInListSerializer < ActiveModel::Serializer
  attributes :id, :title, :source, :author_title, :cover

  def source
    object.source == 'xml' ? nil : "http://#{object.domain}#{object.source}"
  end
end
