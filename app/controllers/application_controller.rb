class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  before_action :redirect_first_login
  before_action :require_login

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      flash[:alert] = "ログインしてください"
      redirect_to items_path
    end
  end

  def redirect_first_login
    return unless logged_in?
    return unless request.get?
    return if request.path.in?([how_to_path, new_item_path, logout_path, root_path]) 
    return unless current_user.first_login?
  
    redirect_to how_to_path
  end
end
