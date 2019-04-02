class Admin::ListsController < Admin::AdminController
  def index
    @items = List.all
  end

  def new
    @list = List.new status: 'unpublished'
    @url = admin_lists_path
  end

  def create
    @list = List::Save.new(list_params, List.new, current_user).call
    if @list.errors.any?
      render :new
    else
      redirect_to admin_lists_path
    end
  end

  def edit
    @list = List.find(params[:id])
    @url = admin_list_path(@list)
    render :new
  end

  def update
    @list = List::Save.new(list_params, List.find(params[:id])).call
    if @list.errors.any?
      render :new
    else
      redirect_to admin_lists_path
    end
  end

  def destroy
    List.find(params[:id]).destroy
    redirect_to admin_lists_path
  end

  def list_params
    params.require(:list).permit(:title, :description, :descriptions, :cover, :status, books_ids: [])
  end
end
