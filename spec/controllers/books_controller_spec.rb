require "rails_helper"
RSpec.describe BooksController, :type => :controller do
  
  # before(:all) do
  #   @user1 = create(:user)
  # end

  let!(:book) {create(:book)}
  
  it "" do
    ap book
    # expect(@user1).to be_valid
  end
end