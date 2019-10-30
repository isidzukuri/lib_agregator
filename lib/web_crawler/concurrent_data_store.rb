# frozen_string_literal: true

module WebCrawler
  class ConcurrentDataSrore
    def initialize(dir)
      time = Time.now.strftime('%d.%m.%Y')
      @path = "#{dir}/data_#{time}.csv"
      @mutex = Mutex.new
    end

    def save_entity(entity)
      mutex.synchronize do
        create_file_for_entity(entity) unless file

        add_row(entity)
      end
    end

    private

    attr_reader :mutex, :file, :path, :headers

    def create_file_for_entity(entity)
      @headers = entity.keys
      FileHelpers.create_dir(path)
      @file = CSV.open(path, 'wb')
      write(headers)
    end

    def add_row(entity)
      write(entity.values_at(*headers))
    end

    def write(row)
      CSV.open(path, 'a+'){|csv| csv << row}
    end
  end
end
