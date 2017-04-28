class Admin::ListsController < Admin::AdminController
  def index
    @items = List.all
  end

  def new
    @list = List.new status: 'unpublished'
    @url = admin_lists_path
  end

  def create
    @list = List.new(list_params)
    @list.user = current_user
    if @list.save
      redirect_to admin_lists_path
    else
      render 'new'
    end
  end

  def edit
    @list = List.find(params[:id])
    @url = admin_list_path(@list)
    render 'new'
  end

  def update
    @list = List.find(params[:id])
    if @list.update(list_params)
      redirect_to admin_lists_path
    else
      render 'new'
    end
  end

  def destroy
    List.find(params[:id]).destroy
    redirect_to admin_lists_path
  end

  def list_params
    params.require(:list).permit(:title, :description, :descriptions, :cover)
  end
end
