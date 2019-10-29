
Build sitemap
```ruby
WebCrawler::Sitemap.build({
        entry_point: 'http://chtyvo.org.ua/',
        pages_pattern: /(?:http:\/\/chtyvo.org.ua\/)?(?:genre\/[A-z]*\/books|authors\/letter\/\d+\/\p{L})(?:\/page-\d+)?/,
        sitemap_items_pattern: /((?:http:\/\/chtyvo.org.ua\/)?authors\/(?!letter).+\/.+\/)"/
      })
```
Will be saved in tmp folder as csv file.


Data miner obj should have implemented `:call` method which returns hash

```ruby
class DummyDataMiner
  def call(url, html)
    {some_key: 'parsed_data'}
  end
end
```

Parse

```ruby
WebCrawler::Parser.new(sitemap_obj, data_miner_obj).call
```
Will return data set. Also data will be saved to the file in tmp folder.
