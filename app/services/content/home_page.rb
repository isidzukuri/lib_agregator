module Content
  class HomePage
    PAPER_BOOKS_KEY = 'paper_books'.freeze
    FREE_BOOKS_KEY = 'free_books'.freeze
    LAST_LISTS_KEY = 'last_lists'.freeze
    LAST_ARTICLES_KEY = 'last_articles'.freeze

    def paper_books
      Base::CachedData.call(PAPER_BOOKS_KEY) do
        ids = Recomendation.pluck(:book_id)
        Book.where(id: ids).select(:title, :seo, :cover, :optimized_cover).order(id: :desc)
      end
    end

    def free_books
      Base::CachedData.call(FREE_BOOKS_KEY) do
        Book.where.not(cover: nil, domain: Book::DOMAINS[:yakaboo]).order('RAND()').limit(20)
      end
    end

    def lists
      Base::CachedData.call(LAST_LISTS_KEY) do
        List.order(id: :desc).where(status: :published).limit(3)
      end
    end

    def articles
      Base::CachedData.call(LAST_ARTICLES_KEY) do
        Article.order(id: :desc).where(status: :published).limit(3)
      end
    end
  end
end
