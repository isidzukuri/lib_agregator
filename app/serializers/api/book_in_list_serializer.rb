class Api::BookInListSerializer < ActiveModel::Serializer
  attributes :id, :title, :source, :author_title, :cover, :paper

  def source
    object.source == 'xml' ? nil : "http://#{object.domain}#{object.source}"
  end

  def paper
    sls_d = "https://rdr.salesdoubler.com.ua/in/offer/269?aid=20647&dlink="
    admitad = "https://ad.admitad.com/g/a4afb4f21a7e808e4236d32ae27335/?ulp="
    object.paper.sub!(sls_d, admitad) if object.paper
  end

  def cover
    object.thumb
  end
end
