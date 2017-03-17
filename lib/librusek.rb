class Librusek < WebParser::Parser
	
	def parse_now
		# add skip urls 
		sitemap = WebParser::Sitemap.new(:threads_number => 10)
		queue = sitemap.get_urls_queue('http://lib.rus.ec/g', '.bookrow1 a:first-child', '.pager-item a', '.main .content a.colorlnk')
		p '---end---'
		# parse(queue)
	end			
		

	def extract_data page
		# validation of data
		# parse site with learning books, pidruchnyky

		result = {
			'title' => title,
			# 'author' => page.search('.author_name_book').text,
			# 'description' => description(page),
			# 'cover' => img(page),
			# 'category' => page.search('[itemprop="genre"]').text.mb_chars.downcase.to_s,
			# 'tags' => page.search('.book_type').text.mb_chars.downcase.to_s,

			# 'paper' => nil,
			# 'txt' => url_for('txt', page),
			# 'rtf' => url_for('rtf', page),
			# 'doc' => url_for('doc', page),
			# 'pdf' => url_for('pdf', page),
			# 'fb2' => url_for('fb2', page),
			# 'ebup' => url_for('ebup', page),
			# 'mobi' => url_for('mobi', page),
			# 'djvu' => url_for('djvu', page),
			'source' => page.uri.path,
			'domain' => page.uri.host
		}
		ap result
		result
	end

	def title page
		str = page.search('.h1.title').text
		str.split(' (')[0]
	end

	# def url_for frmt, page
	# 	file_url = nil
	# 	link = page.link_with(:text => frmt)
	# 	link = page.link_with(:text => "#{frmt}.zip") unless link
	# 	link = page.link_with(:text => "#{frmt}.rar") unless link
	# 	file_url = link.uri.path if link
	# 	file_url
	# end

	# def img page
	# 	img_url = nil
	# 	el = page.search('[itemprop="image"]')
	# 	# img_url = URI.parse(el.attribute('src')).path if el.present?
	# 	img_url = el.attribute('src') if el.present?
	# 	img_url
	# end

	# def description page
	# 	content = page.search('[itemprop="description"]').text
	# 	content = content.gsub! "\r\n", '<br/>' if content.present?
	# 	content
	# end

end

