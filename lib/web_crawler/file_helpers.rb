# frozen_string_literal: true

module WebCrawler
  module FileHelpers
    def self.write(path, data = nil)
      self.create_dir(path)
      file = File.new(path, 'w+')
      file.puts(data)
      file.close
    end

    def self.create_dir(path)
      dirname = File.dirname(path)
      FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
    end
  end
end
