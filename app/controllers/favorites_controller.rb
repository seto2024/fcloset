class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    item = Item.find(params[:item_id])
    current_user.favorites.create(item: item)
    redirect_back fallback_location: items_path, notice: "お気に入りに追加しました"
  end

  def destroy
    favorite = current_user.favorites.find_by(item_id: params[:item_id])
    favorite&.destroy
    redirect_back fallback_location: items_path, notice: "お気に入りを解除しました"
  end
end
