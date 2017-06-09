class WelcomeController < ApplicationController
  # 'shchighol', '1_filosofiia-svobodi', 'liudina-v-poshukakh-spravzhn-ogho-siensu-psikhologh-u-kontstabori', 'moie-zhittia-ta-robota', 'orighinali-iak-nonkonformisti-rukhaiut-svit', 'rework-tsia-knigha-pierieviernie-vash-poghliad-na-biznies', 'ilon-mask-tesla-spacex-i-shliakh-u-fantastichnie-maibutnie', 'chomu-natsiyi-zaniepadaiut-pokhodzhiennia-vladi-baghatstva-i-bidnosti', 'atlant-rozpraviv-pliechi-kompliekt-iz-3-knigh'

  def index
    @paper_books = Book.where(id: [114_629, 78_556, 264_418, 78_153, 85_199, 65_867, 101_084, 87_251, 101_015]).select(:title, :seo, :cover).order(id: :desc)
    @free_books = free_books
    @lists = lists()
    @articles = articles()
  end

  private

  def free_books
    items = $cache.read('free_books')
    unless items
      items = Book.where(paper: nil).where.not(cover: nil).order('RAND()').limit(20)
      $cache.write('free_books', items, expires_in: 1.day)
    end
    items
  end

  def lists
    items = $cache.read('last_lists')
    unless items
      items = List.order(id: :desc).where(status: 'published').limit(3)
      $cache.write('last_lists', items, expires_in: 1.day)
    end
    items
  end


  def articles
    items = $cache.read('last_articles')
    unless items
      items = Article.order(id: :desc).where(status: 'published').limit(3)
      $cache.write('last_articles', items, expires_in: 1.day)
    end
    items
  end
end
