class WelcomeController < ApplicationController
  # 'shchighol', '1_filosofiia-svobodi', 'liudina-v-poshukakh-spravzhn-ogho-siensu-psikhologh-u-kontstabori', 'moie-zhittia-ta-robota', 'orighinali-iak-nonkonformisti-rukhaiut-svit', 'rework-tsia-knigha-pierieviernie-vash-poghliad-na-biznies', 'ilon-mask-tesla-spacex-i-shliakh-u-fantastichnie-maibutnie', 'chomu-natsiyi-zaniepadaiut-pokhodzhiennia-vladi-baghatstva-i-bidnosti', 'atlant-rozpraviv-pliechi-kompliekt-iz-3-knigh'
  caches_action :index, expires_in: 12.hour

  def index
    @paper_books = paper_books
    @free_books = free_books
    @lists = lists
    @articles = articles
  end

  private

  def paper_books
    Base::CachedData.call('paper_books') do
      ids = Recomendation.pluck(:book_id)
      Book.where(id: ids).select(:title, :seo, :cover, :optimized_cover).order(id: :desc)
    end
  end

  def free_books
    Base::CachedData.call('free_books') do
      Book.where.not(cover: nil, domain: 'yakaboo.ua').order('RAND()').limit(20)
    end
  end

  def lists
    Base::CachedData.call('last_lists') do
      List.order(id: :desc).where(status: :published).limit(3)
    end
  end

  def articles
    Base::CachedData.call('last_articles') do
      Article.order(id: :desc).where(status: :published).limit(3)
    end
  end
end
