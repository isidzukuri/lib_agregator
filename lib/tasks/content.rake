namespace :content do
  desc "TODO"
  task optimize_yakaboo_images: :environment do

    books = Book.where(domain: "yakaboo.ua", optimized_cover: nil).where.not(cover: nil).select(:id, :cover).all
    queue = WebParser::SimpleQueue.new(books.to_a)
    threads = []
    fails = 0
    40.times do 
      threads << Thread.new do
        book = queue.next_item
        while book do
          begin
            ext = book.cover.split('.').last
            image = MiniMagick::Image.open(book.cover)
            image.resize "280x350\>"
            filename = "#{book.id}.#{ext}"
            image.write("public/covers/#{filename}")
            `mogrify -quality 80 public/covers/#{filename}`

            # book.update_attribute(:optimized_cover, filename)
          rescue
            fails +=1
          end
          book = queue.next_item
        end
      end
    end
    threads.each { |thr| thr.join }
    puts "fails: #{fails}".red
    puts "[end]".green
  end

  task update_optimized_cover: :environment do
    books = Book.where(domain: "yakaboo.ua").select(:id, :cover).all.each do |book|
      ext = book.cover.split('.').last
      filename = "#{book.id}.#{ext}"
      book.update_attribute(:optimized_cover, filename)
    end     
  end
end
