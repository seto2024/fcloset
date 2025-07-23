class HowTosController < ApplicationController
  before_action :require_login

  def show
    # first_loginがtrueならfalseにして1回だけ表示
    if current_user.first_login?
      current_user.update(first_login: false)
    else
      redirect_to items_path
    end
  end
end
