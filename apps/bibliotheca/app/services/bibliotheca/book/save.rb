module Bibliotheca
class Book::Save
  def initialize(params, item)
    @params = params
    @item = item
  end

  attr_accessor :params, :item

  def call
    assign_authors
    item.assign_attributes(params)
    assign_formats
    cover_changed = item.cover_changed?
    item.save
    optimize_cover if cover_changed

    item
  end

  private

  def assign_formats
    Book::FORMATS.each do |format|
      item[format] = params[format].presence
    end
  end

  def assign_authors
    item.authors = Author.where(id: params[:authors_ids])
    params.delete :authors_ids
  end

  def optimize_cover
    return unless item.cover.present?

    ext = item.cover.split('.').last
    image = MiniMagick::Image.open(item.cover)
    image.resize "280x350\>"
    filename = "#{item.id}.#{ext}"
    image.write("public/covers/#{filename}")
    `mogrify -quality 80 public/covers/#{filename}`
    item.update_attribute(:optimized_cover, filename)
  end
end
end
