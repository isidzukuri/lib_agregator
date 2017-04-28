class SaveList

  def initialize params, item = nil
    @params = params
    @item = item ? item : List.new
    # article.attributes = article_params
    
  end

  attr_accessor :params, :item
end
