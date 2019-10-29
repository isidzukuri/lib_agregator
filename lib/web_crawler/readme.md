Most interesting thing about this library its dynamically spawned threads. Why its needed?
For example you have one job to do. Its easy: one job - one thread. 2 jobs - 2 threads ... n jobs - n threads (in ideal world).
But what if you dont know about number of jobs should be done at the start? Or number will change in the middle of the process?
It would be cool if code could decide about optimal number of threads in each moment of time.


Build sitemap
```ruby
WebCrawler::Sitemap.build({
        entry_point: 'http://chtyvo.org.ua/',
        pages_pattern: /(?:http:\/\/chtyvo.org.ua\/)?(?:genre\/[A-z]*\/books|authors\/letter\/\d+\/\p{L})(?:\/page-\d+)?/,
        sitemap_items_pattern: /((?:http:\/\/chtyvo.org.ua\/)?authors\/(?!letter).+\/.+\/)"/
      })
```
Returns set of urls. Will be saved in tmp folder as csv file.


Data miner obj should have implemented `:call` method which returns hash

```ruby
class DummyDataMiner
  def call(url, html)
    {some_key: 'parsed_data'}
  end
end
```

Parse website:

```ruby
WebCrawler::Parser.new(sitemap_obj, data_miner_obj).call
```
Will return data set. Also data will be saved to the file in tmp folder.
