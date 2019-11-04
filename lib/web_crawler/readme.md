Most interesting thing about this library its dynamically spawned threads. Why its needed?
For example you have one job to do. Its easy: one job - one thread. 2 jobs - 2 threads ... n jobs - n threads (in ideal world).
But what if you dont know  at the start about number of jobs should be done? Or if number will change during the process?
It would be cool if code could decide about optimal number of threads in each moment of time.

Logic begind is simple: if queue of jobs is big - start new threads. Thread dies if no jobs left.


Build sitemap:
```ruby
WebCrawler::Sitemap.build({
        entry_point: 'http://chtyvo.org.ua/',
        pages_pattern: /(?:http:\/\/chtyvo.org.ua\/)?(?:genre\/[A-z]*\/books|authors\/letter\/\d+\/\p{L})(?:\/page-\d+)?/,
        sitemap_items_pattern: /((?:http:\/\/chtyvo.org.ua\/)?authors\/(?!letter).+\/.+\/)"/
      })
```
Returns set of urls. The set saved in `/tmp` folder as csv file.
Process visit page(`:entry_point`) at the  start. It starts looking there for links to pages(`:pages_pattern`) which contains urls(`:sitemap_items_pattern`) which are saved to the sitemap.


Parse website:

```ruby
WebCrawler::Parser.new(sitemap_obj, data_miner_obj).call
```
Returns data set. Also data will be saved to the file in tmp folder.


Data miner obj should respond to `:call` and return hash

```ruby
class DummyDataMiner
  def call(url, html)
    {some_key: 'parsed_data'}
  end
end
```
