class WelcomeController < ApplicationController
  # 'shchighol', '1_filosofiia-svobodi', 'liudina-v-poshukakh-spravzhn-ogho-siensu-psikhologh-u-kontstabori', 'moie-zhittia-ta-robota', 'orighinali-iak-nonkonformisti-rukhaiut-svit', 'rework-tsia-knigha-pierieviernie-vash-poghliad-na-biznies', 'ilon-mask-tesla-spacex-i-shliakh-u-fantastichnie-maibutnie', 'chomu-natsiyi-zaniepadaiut-pokhodzhiennia-vladi-baghatstva-i-bidnosti', 'atlant-rozpraviv-pliechi-kompliekt-iz-3-knigh'

  def index
    @paper_books = Book.where(id: [114_629, 78_556, 264_418, 78_153, 85_199, 65_867, 101_084, 87_251, 101_015]).select(:title, :seo, :cover).order(id: :desc)
    @free_books = free_books
  end

  private

  def free_books
    items = $cache.read('free_books')
    unless items
      items = Book.where(paper: nil).where.not(cover: nil).order('RAND()').limit(12)
      $cache.write('free_books', items, expires_in: 1.day)
    end
    items
  end
end
