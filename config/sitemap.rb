# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://findbook.in.ua"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add 'genres/'
  # add 'genres/:key'
  add 'tags/'
  # add 'tags/:key'
  add 'authors/'
  # add 'authors/:key'
  # add 'books/:key'

  Tag.select(:id, :seo).find_each do |item|
    add "tags/#{item.seo}"
  end

  Genre.select(:id, :seo).find_each do |item|
    add "genres/#{item.seo}"
  end

  Author.select(:id, :seo).find_each do |item|
    add "authors/#{item.seo}"
  end

  Book.select(:id, :seo).find_each do |item|
    add "books/#{item.seo}"
  end

  
end
