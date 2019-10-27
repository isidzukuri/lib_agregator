# frozen_string_literal: true

module WebCrawler
  module FileHelpers
    def self.write(path, data)
      dirname = File.dirname(path)
      FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
      file = File.new(path, 'w+')
      file.puts(data)
      file.close
    end
  end
end
