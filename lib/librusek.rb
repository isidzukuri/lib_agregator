class Librusek < WebParser::Parser


	# translate main genres to uk. Take main from original site
	# add if not present in db


	# translate tags
	# translate authors
# [283086/366870] http://lib.rus.ec/b/91302


	def parse_now
		sitemap = WebParser::Sitemap.new(:threads_number => 10)
		queue = sitemap.get_urls_queue('http://lib.rus.ec/g', {href: /\/b\/\d.*(?<!\bdownload|read)$/}, '.pager-item a', '.main .content a.colorlnk', true)
		# ap queue.store
		# p '---end---'
		# queue = WebParser::SimpleQueue.new(['http://lib.rus.ec/b/241557', 'http://lib.rus.ec/b/618608'])
		@skip.times {queue.next_item } if @skip
		parse(queue)
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
		return if !page.search('._ga1_on_').present?
		return if !is_ua?(page)
		return if !download_format(page).present?

		# ap page.uri.path

		# ap "ukrainian:"
		# ap is_ua?(page)
		# ap  "include fb2:"
		# ap download_format(page).present?

		result = {
			'title' => title(page),
			'author' => author(page),
			'category' => category(page), 
			'tags' => tags(page),
			'description' => description(page),
			'source' => page.uri.path,
			'domain' => page.uri.host
		}
		result.merge!(download_format(page))
		
		result
	end

	def title page
		str = page.search('h1.title').text

		str.split(' (')[0]
	end

	def author page
		page.links_with(href: /\/a\/\d/)[0].text
	end

	def tags page
		arr = []
		page.search('a.genre h9').each_with_index do |tag, i|
			next if i == 0
			arr << tag.text.mb_chars.downcase.to_s
		end


		page.search('.vocabulary-tag a').each_with_index do |tag, i|
			next if i == 0
			arr << tag.text.mb_chars.downcase.to_s
		end
		arr
	end

	def description page
		str = ''
		html_str = page.search('._ga1_on_ h2 + p').to_html
		str = Sanitize.fragment(html_str, elements: %w(b ul ol li p br u i h5 strong pre small)) if html_str
		str
	end

	def download_format page
		frmts = {}
		title_str = page.search('h1.title').text
		['txt', 'rtf', 'doc', 'pdf', 'fb2', 'epub', 'mobi', 'djvu'].each do |f|
			next unless title_str.include?("(#{f})")
			path = page.link_with(:text => /скачать/).uri.path
			frmts[f] = "http://#{page.uri.host}#{path}"
		end
		frmts
	end

	def is_ua? page
		page.search('._ga1_on_').text.include?(' [uk] ')
	end

	def category page
		str = ''
		elements = page.search('a.genre h9')
		str = elements[0].text.mb_chars.downcase.to_s if elements
		str
	end



	# GENRES = {
	# 	'' => '',
	# }

end

