class ItemsController < ApplicationController
  before_action :redirect_first_login
  before_action :set_item, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @items = current_user&.items || []
  
    @items = @items.where(category: params[:category]) if params[:category].present?
    @items = @items.where(brand: params[:brand]) if params[:brand].present?
    @items = @items.where(color: params[:color]) if params[:color].present?
  
    if params[:keyword].present?
      keyword = params[:keyword].downcase
      @items = @items.where("LOWER(keyword1) = ? OR LOWER(keyword2) = ?", keyword, keyword)
    end
  
  
    if params[:sort] == 'price_asc'
      @items = @items.order(price: :asc)
    elsif params[:sort] == 'price_desc'
      @items = @items.order(Arel.sql('price DESC NULLS LAST'))
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = current_user.items.build(item_params) 
    if @item.save
      current_user.update_column(:first_login, false) if current_user.first_login?
      redirect_to items_path, notice: "アイテムを登録しました"
    else
      flash.now[:alert] = "登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to items_path, notice: "アイテムを更新しました"
    else
      flash.now[:alert] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: "アイテムを削除しました"
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:image, :name, :description, :brand, :category, :price, :color, :keyword1, :keyword2 )
  end

  def redirect_first_login
    return unless user_signed_in? && current_user.first_login?
    return if request.path == settings_path || request.path == destroy_user_session_path

    redirect_to settings_path
  end
end
