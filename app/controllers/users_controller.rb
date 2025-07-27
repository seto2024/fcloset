class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.merge(first_login: true))  # ←ここ！
    if @user.save
   redirect_to login_path, notice: "登録が完了しました。ログインしてください。"
    else
      flash.now[:alert] = '登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @user = current_user
    @themes = Theme.all
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to edit_user_path, notice: "テーマを変更しました！"
    else
      @themes = Theme.all
      flash.now[:alert] = '更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end
    
  private
    
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
