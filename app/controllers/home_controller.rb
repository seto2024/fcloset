class HomeController < ApplicationController
  skip_before_action :require_login
  skip_before_action :redirect_first_login

  def index
    redirect_to items_path if logged_in?
  end
end
