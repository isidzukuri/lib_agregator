
Build sitemap
```ruby
WebCrawler::Sitemap.build({
        entry_point: 'http://chtyvo.org.ua/',
        pages_pattern: /(?:http:\/\/chtyvo.org.ua\/)?(?:genre\/[A-z]*\/books|authors\/letter\/\d+\/\p{L})(?:\/page-\d+)?/,
        sitemap_items_pattern: /((?:http:\/\/chtyvo.org.ua\/)?authors\/(?!letter).+\/.+\/)"/
      })
```
Will be saved in tmp folder as csv file.
