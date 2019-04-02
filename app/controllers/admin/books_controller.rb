class Admin::BooksController < Admin::AdminController
  def index
    @items = Book.paginate(page: params[:page], per_page: @per_page)
  end

  # def new
  #   @book = Book.new
  #   @url = admin_books_path
  # end

  # def create
  #   @book = Book.new(book_params)
  #   @book.user = current_user
  #   if @book.save
  #     LibAgreagator::CACHE.delete('last_books')
  #     redirect_to admin_books_path
  #   else
  #     render 'new'
  #   end
  # end

  def edit
    @book = Book.find_by_seo(params[:id])
    @url = admin_book_path(@book)
    render 'new'
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to admin_books_path
    else
      render 'new'
    end
  end

  def destroy
    Book.find(params[:id]).destroy
    redirect_to admin_books_path
  end

  def book_params
    params.require(:book).permit(:title, :description, :cover, :hide)
  end
end
