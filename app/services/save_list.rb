class SaveList

  def initialize params, item, user = nil
    @params = params
    @item = item  
    @user = user
  end

  attr_accessor :params, :item, :user

  def call
    item.attributes = params
    if params[:books_ids]
      item.books = Book.where(id: params[:books_ids])
      params.delete :books_ids
    end
    item.user = user if user
    item.save
    item
  end
end
