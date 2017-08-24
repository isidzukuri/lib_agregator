class Yakaboo < WebParser::Parser


	def parse_now
		sitemap = WebParser::Sitemap.new(:threads_number => 10)
		queue = sitemap.get_urls_queue('http://www.yakaboo.ua/jelektronnye-knigi.html', '.item__layout .content a', '.paginator_page a', '.col-left.sidebar .block-categories-list:first-child a', true)
		# ap queue.store
		# p '---end---'

		# queue = WebParser::SimpleQueue.new(['http://www.yakaboo.ua/majdan-vid-pershoi-osobi-45-istorij-revoljucii-gidnosti.html', 'http://www.yakaboo.ua/schigol-1570198.html'])
		@skip.times {queue.next_item } if @skip
		parse(queue)
	end			

	def extract_data page
		return nil if page.is_a?(Integer)
		result = {
			'title' => title(page),
			'author' => author(page),
			'picture' => picture(page),
			'categories' => categories(page),
			'description' => description(page),
			'source' => page.uri.path,
			'domain' => page.uri.host,
		}
		result.merge!(formats(page))

		# ap result
		
		result
		
	end

	def title page
		page.search('#product-title h1').text
	end

	def author page
		res = nil
		a_links = page.links_with(href: /\/author\//)
		res = a_links[0].text if a_links.present?
		res
	end

	def formats page
		frmts = {}
		page.search('.product-attributes #downloadable-links-list span').each do |frmt|
			frmts[frmt.text] = page.uri.to_s
		end
		frmts
	end

	def description page
		str = ''
		html_str = page.search('#product-description .unit__content').to_html
		str = Sanitize.fragment(html_str, elements: %w(b ul ol li p br u i h5 strong pre small)).strip if html_str
		str
	end

	def picture page
		el = page.search('#image')
		el.present? ? el.attribute('src').text : nil
	end

	def categories page
		res = []
		page.search('.breadcrumb li a').each_with_index do |c, i|
			next if i == 0 || i == 1			
			res << c.text.strip.mb_chars.downcase.to_s
		end
		res
	end

end

