class Bambook < WebParser::Parser


  # translate main genres to uk. Take main from original site
  # add if not present in db


  # translate tags
  # translate authors
# [283086/366870] http://lib.rus.ec/b/91302


  def parse_now
    sitemap = BambookSitemap.new(:threads_number => 10, :path_suffix => '/scripts/')
    queue = sitemap.get_urls_queue(
      'http://www.bambook.com/scripts/catalog.sect?v=2&sid=10&xcustid=0', 
      {href: /pos.showitem/}, {href: /catalog.sect\?v=2&sid=\d+&vs=/},  {href: /&sid=\d+/}, false)
    # ap queue.store
    # p '---end---'
    # queue = WebParser::SimpleQueue.new(['http://www.bambook.com/scripts/pos.showitem?v=2&ite=841407','http://www.bambook.com/scripts/pos.showitem?v=2&ite=1626909','http://www.bambook.com/scripts/pos.showitem?v=2&ite=1639474', 'http://www.bambook.com/scripts/pos.showitem?v=2&ite=1288118', 'http://www.bambook.com/scripts/pos.showitem?v=2&ite=15487', 'http://www.bambook.com/scripts/pos.showitem?v=2&ite=16437', 'http://www.bambook.com/scripts/pos.showitem?v=2&ite=1288485'])
    # @skip.times {queue.next_item } if @skip
    # parse(queue)
  end     


  def save_data
    prefix = self.class.to_s.split('<')[0]

    @data = []
    
    Dir["public/#{name_prefix}/parts/*"].each do |file|
      begin
        @data += JSON.parse(open(file).read)
      rescue
      end
    end

    append("public/#{name_prefix}/data_#{DateTime.now.strftime('%Y_%m_%d')}.json", data.uniq.to_json) if data.present?
  end
    
  def save_part
    shifted_count = @url_queue.shifted
    return unless (shifted_count % 100 == 0 ) || @url_queue.items_left == 0
    part_number = shifted_count/100

    append("public/#{name_prefix}/parts/#{part_number}.json", data.shift(100).to_json)
  end

  def extract_data page
    save_part()
    return if !is_ua?(page)
    return if !available?(page)

    # ap is_ua?(page)
    # ap available?(page)

    

    result = {
      'title' => title(page),
      'author' => author(page),
      'cover' => cover(page),
      'tags' => tags(page),
      'description' => description(page),
      'source' => page.uri.to_s,
      'domain' => page.uri.host
    }
    
    result
  end

  def title page
    page.search('[itemprop="name"]').text
  end

  def author page
    page.search('[itemprop="author"]').attribute('content').to_s
  end

  def cover page
    val = ''
    elm = page.search('[itemprop="image"]')
    val = elm.attribute('content').to_s if elm.present?
    val
  end

  def tags page
    elms = page.search('[itemtype="http://data-vocabulary.org/Breadcrumb"] a')
    arr = []
    elms.each_with_index do |tag, i|
      next if i == 0
      str = tag.text.mb_chars.downcase.to_s
      next if ['акции и предложения', "новые поступления", "разное"].include?(str)
      arr << str
    end

    arr
  end

  def description page
    str = ''
    html_str = page.search('[itemprop="description"]').to_html
    str = Sanitize.fragment(html_str, elements: %w(b ul ol li p br u i h5 strong pre small)) if html_str
    str
  end

  def is_ua? page
    page.search('[itemprop="inLanguage"]').text == 'Украинский'
  end

  def available? page
    page.search('.hidden_buy').present?
  end

end

class BambookSitemap < WebParser::Sitemap

  def get_urls_from_categories(url, attribute, agent = nil)
    puts "#{url} checking categories".green
    pages_with_paginator, agent  = urls_from_page_by_attribute(url, attribute, agent)

    sub_categories = []
    pages_with_paginator.each do |category_url|
      puts " - #{category_url} checking sub category".green
      sub_category_links, agent  = urls_from_page_by_attribute(category_url, attribute, agent)
      sub_categories += sub_category_links #sub categories
    end
    pages_with_paginator += sub_categories

    return pages_with_paginator.uniq!, agent 
  end

end