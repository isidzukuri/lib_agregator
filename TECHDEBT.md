- clean controllers from logic, move it to services
- rewrite parser
                                                      - upload book covers to amazon
- separate into engines: base, api, admin, library 


- replace tire gem
- upgrade elastic
  use https://github.com/elastic/elasticsearch-rails
  add env var ELASTICSEARCH_URL
  use https://github.com/bkeepers/dotenv
  create .env
  run elastic in docker
  set mapping in Book, Author for elastic
  make it shared file for all releases
  edit class Author, Book::ExtendedSearchQuery, Book::SearchByTitleQuery
  index data, add new books and index again. Does new rows appeared in elasic?
  does elastic from docker persist data do hdd?
