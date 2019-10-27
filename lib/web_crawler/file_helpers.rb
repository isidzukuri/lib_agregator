# frozen_string_literal: true

module WebCrawler
  module FileHelpers

    def self.write path, data
      dirname = File.dirname(path)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end
      file = File.new(path, 'w+')
      file.puts(data)
      file.close
    end
  end
end
