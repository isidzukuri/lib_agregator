module BooksMining
  class ChtyvoDataMiner

    def call(url, page)
      return nil unless page && url

      uri = URI(url)
      page = Nokogiri::HTML(page)

      {
        title: page.search('.book_name').text,
        author: page.search('.author_name_book').text,
        description: description(page),
        cover: img(page),
        category: page.search('[itemprop="genre"]').text.mb_chars.downcase.to_s,
        tags: page.search('.book_type').text.mb_chars.downcase.to_s,

        paper: nil,
        txt: url_for('txt', page),
        rtf: url_for('rtf', page),
        doc: url_for('doc', page),
        pdf: url_for('pdf', page),
        fb2: url_for('fb2', page),
        epub: url_for('epub', page),
        mobi: url_for('mobi', page),
        djvu: url_for('djvu', page),
        source: uri.path,
        domain: uri.host
      }
    end

    def url_for(frmt, page)
      file_url = nil

      link = page.at("a:contains('#{frmt}')")
      link = page.at("a:contains('#{frmt}.zip')") unless link
      link = page.at("a:contains('#{frmt}.rar')") unless link

      file_url = URI(link[:href]).path if link
      file_url
    end

    def img(page)
      img_url = nil
      el = page.search('[itemprop="image"]')
      img_url = el.attribute('src').to_s if el.present? && el.attribute('src').to_s != '[]'
      img_url
    end

    def description(page)
      content = page.search('[itemprop="description"]').text
      content = content.gsub! "\r\n", '<br/>' if content.present?
      content
    end
  end
end
