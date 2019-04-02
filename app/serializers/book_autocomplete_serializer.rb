class BookAutocompleteSerializer < ActiveModel::Serializer
  attributes :id, :title, :author_title, :value

  def value
    str = object.title
    str += ". #{object.author_title}" if object.author_title.present?
    str += " [PO]" if Book.only_paper?(object)
    str
  end
end
