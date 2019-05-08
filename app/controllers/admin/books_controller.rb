class Admin::BooksController < Admin::AdminController
  def index
    @items = Book.paginate(page: params[:page], per_page: @per_page)
  end

  def new
    @book = Book.new
    @url = admin_books_path
  end

  def create
    @book = Book::Save.new(book_params, Book.new).call

    unless @book.errors.any?
      redirect_to admin_books_path
    end
  end

  def edit
    @book = Book.find_by_seo(params[:id])
    @url = admin_book_path(@book)
  end

  def update
    @book = Book.find(params[:id])

    Book::Save.new(book_params, @book).call

    unless @book.errors.any?
      redirect_to admin_books_path
    end
  end

  def destroy
    Book.find(params[:id]).destroy
    redirect_to admin_books_path
  end

  private

  def book_params
    allowed_attrs = Book::FORMATS + [:title, :description, :cover, :hide, :source, :domain, :language, authors_ids: []]
    params.require(:book).permit(allowed_attrs)
  end
end
