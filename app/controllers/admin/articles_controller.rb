class Admin::ArticlesController < Admin::AdminController
 
    def index
        @items = Article.all
    end


    def new
        @article = Article.new status: 'unpublished'
        @url = admin_articles_path
    end

    def create
        @article = Article.new(article_params)
        @article.user = current_user
        if @article.save
          redirect_to admin_articles_path
        else
          render "new"
        end
    end

    def edit
        @article = Article.find(params[:id])
        @url = admin_article_path(@article)
        render 'new'
    end

    def update
      @article = Article.find(params[:id])
      if @article.update(article_params)
        redirect_to admin_articles_path
      else
        render "new"
      end
    end


    def destroy
      Article.find(params[:id]).destroy
      redirect_to admin_articles_path
    end



    def article_params
        params.require(:article).permit(:title, :description, :text, :status, :cover)
    end
end
