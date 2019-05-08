class Admin::AuthorsController < Admin::AdminController
  
  def autocomplete
    items = Author::AutocompleteQuery.new(word: params[:term]).call

    render json: items, each_serializer: AuthorAutocompleteSerializer
  end

  def index
    @items = Author.paginate(page: params[:page], per_page: @per_page)
  end

  def new
    @author = Author.new
    @url = admin_authors_path
  end

  def create
    @author = Author.create(author_params)
    
    redirect_to(admin_authors_path) unless @author.errors.any?
  end

  def edit
    @author = Author.find_by_seo(params[:id])
    @url = admin_author_path(@author)
  end

  def update
    @author = Author.find(params[:id])
    if @author.update(author_params)
      redirect_to admin_authors_path
    end
  end

  def destroy
    Author.find(params[:id]).destroy
    redirect_to admin_authors_path
  end

  private

  def author_params
    params.require(:author).permit(:full_name, :first_name, :last_name, :uk, :hide)
  end
end
