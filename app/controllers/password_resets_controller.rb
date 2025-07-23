class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      @user.deliver_reset_password_instructions!
      redirect_to login_path, notice: 'パスワード再設定用のメールを送信しました'
    else
      flash.now[:alert] = 'メールアドレスが見つかりません'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @token = params[:token]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated unless @user
  end

  def update
    @token = params[:token]
    @user = User.load_from_reset_password_token(@token)
    return not_authenticated unless @user

    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.save
      redirect_to login_path, notice: 'パスワードを変更しました'
    else
      flash.now[:alert] = 'パスワードの変更に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end
end
