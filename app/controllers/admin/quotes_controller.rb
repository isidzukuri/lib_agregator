class Admin::QuotesController < Admin::AdminController
  def index
    @items = Quote.paginate(page: params[:page], per_page: @per_page)
  end

  def new
    @quote = Quote.new
    @url = admin_quotes_path
  end

  def create
    @quote = Quote::Save.new(quote_params, Quote.new, current_user).call
    if @quote.errors.any?
      render :new
    else
      redirect_to admin_quotes_path
    end
  end

  def edit
    @quote = Quote.find(params[:id])
    @url = admin_quote_path(@quote)
    render :new
  end

  def update
    @quote = Quote::Save.new(quote_params, Quote.find(params[:id])).call
    if @quote.errors.any?
      render :new
    else
      redirect_to admin_quotes_path
    end
  end

  def destroy
    Quote.find(params[:id]).destroy
    redirect_to admin_quotes_path
  end

  def quote_params
    params.require(:quote).permit(:text, :book_name, :author_name, :book_id, :hide)
  end
end
