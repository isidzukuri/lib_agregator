# RSpec.describe Bibliotheca::ArticlesController, type: :request do
#   describe "request list of all users" do
#     # user = User.create(name: “Test user”)
#     get articles_path
#     # expect(response).to be_successful
#     # expect(response.body).to include(“Test user”)
#   end
# end

RSpec.describe Bibliotheca::ArticlesController, type: :controller do
  routes { Bibliotheca::Engine.routes }

  describe "request list of all users" do
    # user = User.create(name: “Test user”)
    # get articles_path

    # p articles_path
    it '' do
      get :index
    end
    # expect(response).to be_successful
    # expect(response.body).to include(“Test user”)
  end
end
