namespace :content do
  desc "TODO"
  task optimize_yakaboo_images: :environment do

    books = Book.where(domain: "yakaboo.ua", optimized_cover: nil).where.not(cover: nil).select(:id, :cover).all
    queue = WebParser::SimpleQueue.new(books.to_a)


    threads = []
    fails = 0
    60.times do 
      threads << Thread.new do
        book = queue.next_item
        while book do
          begin
            ext = book.cover.split('.').last
            image = MiniMagick::Image.open(book.cover)
            image.resize "280x350\>"
            filename = "#{book.id}.#{ext}"
            image.write("public/covers/#{filename}")
            book.update_attribute(:optimized_cover, filename)
          rescue
            fails +=1
          end
          book = queue.next_item
        end
      end
    end
    threads.each { |thr| thr.join }
    # profiler = RubyProf.stop
    # printer = RubyProf::GraphPrinter.new(profiler)
    # printer.print(STDOUT, {})
    puts "fails: #{fails}".red
    puts "[end]".green
    

  end

end
