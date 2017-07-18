namespace :content do
  desc "TODO"
  task optimize_yakaboo_images: :environment do
    Book.where(domain: "yakaboo.ua").where.not(cover: nil).select(:id, :cover).all.each do |book|
      ext = book.cover.split('.').last
      image = MiniMagick::Image.open(book.cover)
      image.resize "280x350\>"
      filename = "#{book.id}.#{ext}"
      image.write("public/covers/#{filename}")
      book.update_attribute(:optimized_cover, filename)
    end
  end

end
