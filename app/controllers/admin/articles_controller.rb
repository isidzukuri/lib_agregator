class Admin::ArticlesController < Admin::AdminController
 
    def index
        
    end


    def new
        @article = Article.new status: 'unpublished'
    end

    def create
        
    end

end
