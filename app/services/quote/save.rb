class Quote::Save

  def initialize params, item, user = nil
    @params = params
    @item = item  
    @user = user
  end

  attr_accessor :params, :item, :user

  def call
    item.attributes = params
    item.user = user if user
    item.save
    $cache.delete('last_lists')
    item
  end
end
