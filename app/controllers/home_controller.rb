class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :redirect_first_login, raise: false

  def index
    redirect_to items_path if user_signed_in?
  end
end
