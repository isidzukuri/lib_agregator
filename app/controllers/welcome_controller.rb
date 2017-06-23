class WelcomeController < ApplicationController
  # 'shchighol', '1_filosofiia-svobodi', 'liudina-v-poshukakh-spravzhn-ogho-siensu-psikhologh-u-kontstabori', 'moie-zhittia-ta-robota', 'orighinali-iak-nonkonformisti-rukhaiut-svit', 'rework-tsia-knigha-pierieviernie-vash-poghliad-na-biznies', 'ilon-mask-tesla-spacex-i-shliakh-u-fantastichnie-maibutnie', 'chomu-natsiyi-zaniepadaiut-pokhodzhiennia-vladi-baghatstva-i-bidnosti', 'atlant-rozpraviv-pliechi-kompliekt-iz-3-knigh'

  def index
    @paper_books = paper_books
    @free_books = free_books
    @lists = lists()
    @articles = articles()
  end

  private

  def paper_books
    items = $cache.read('paper_books')
    # unless items
      ids = Recomendation.pluck(:book_id)
      items = Book.where(id: ids).select(:title, :seo, :cover).order(id: :desc)
      $cache.write('paper_books', items, expires_in: 1.day)
    # end
    items
  end

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
