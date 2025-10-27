class SettingsController < ApplicationController

  def show
    @themes = Theme.all
  end

  def update
    if current_user.update(theme_params)
      redirect_to settings_path, notice: "テーマを変更しました"
    else
      flash.now[:alert] = "テーマの変更に失敗しました"
      @themes = Theme.all
      render :show, status: :unprocessable_entity
    end
  end

  private

  def theme_params
    params.require(:user).permit(:theme_id)
  end
end
