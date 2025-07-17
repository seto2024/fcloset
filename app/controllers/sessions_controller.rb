class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

    def new
    end
  
    def create
      @user = login(params[:email], params[:password])
      if @user
        redirect_to root_path, notice: 'ログインしました！'
      else
        puts "ログイン失敗"
        flash.now[:alert] = 'ログインに失敗しました'
        render :new, status: :unprocessable_entity
      end
    end
  
    def destroy
      logout
      redirect_to root_path, notice: 'ログアウトしました'
    end
  end
