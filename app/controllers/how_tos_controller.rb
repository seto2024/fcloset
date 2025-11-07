class HowTosController < ApplicationController

skip_before_action :redirect_first_login, only: [:show, :welcome, :share_closet]

  def show
  end

  def welcome
    if current_user.first_login?
      current_user.update(first_login: false)
    else
      redirect_to items_path
    end
  end
  
  def share_closet
  end
end
