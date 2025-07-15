class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, notice: '新規登録しました！'
    else
      flash.now[:alert] = '登録に失敗しました'
      render :new
    end
  end
    
  private
    
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
