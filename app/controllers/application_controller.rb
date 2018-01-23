class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :paginator_params, :set_vars

  def paginator_params
    @per_page = 100
    @page = params[:page] ? params[:page].to_i : 0
    @offset = @page * @per_page
  end

  def set_vars
    @current_path = request.fullpath.split('?')[0]
  end

  def cached(cache_key, expires_in = 1.day)
    result = $cache.read(cache_key)
    if result.nil?
      result = yield
      $cache.write(cache_key, result, expires_in: expires_in)
    end
    result
  end
  
end
