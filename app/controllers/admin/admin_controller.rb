class Admin::AdminController < ApplicationController
  before_action :authenticate_user!, :check_admin!

  def index; end

  def check_admin!
    redirect_to :root if current_user.role != 'admin'
  end
end
