class SessionsController < ApplicationController
    def new
    end
  
    def create
      @user = login(params[:email], params[:password])
      if @user
        redirect_to root_path, notice: 'ログインしました！'
      else
        puts "ログイン失敗"
        flash[:alert] = 'ログインに失敗しました'
        render :new
      end
    end
  
    def destroy
      logout
      redirect_to root_path, notice: 'ログアウトしました'
    end
  end
