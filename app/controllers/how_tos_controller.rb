class HowTosController < ApplicationController
  def show
  end

  def welcome
    if current_user.first_login?
      current_user.update(first_login: false)
    else
      redirect_to items_path
    end
  end
end
