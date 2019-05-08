class AuthorAutocompleteSerializer < ActiveModel::Serializer
  attributes :id, :value

  def value
    object.full_name
  end
end
