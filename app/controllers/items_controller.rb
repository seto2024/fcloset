class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_first_login, except: [:quick_new, :quick_create]
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = current_user.items

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
    @tags = Tag.all
  end

  def create
    @item = current_user.items.build(item_params)
    if @item.save
      current_user.update_column(:first_login, false) if current_user.first_login?
      redirect_to items_path, notice: "アイテムを登録しました"
    else
      @tags = Tag.all 
      flash.now[:alert] = "登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    @item = Item.find(params[:id])
    @tags = Tag.all
  end

  def update
    if @item.update(item_params)
      redirect_to items_path, notice: "アイテムを更新しました"
    else
      @tags = Tag.all 
      flash.now[:alert] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: "アイテムを削除しました"
  end

  def favorites
    @items = current_user.favorite_items
  end

  def quick_new
    @item = Item.new
  end

  def quick_create
    @item = current_user.items.build(item_params)

    if @item.name.present? || @item.image.attached?
      if @item.save
        current_user.update(first_login: false)
        redirect_to items_path, notice: "アイテムを登録しました！"
      else
        flash.now[:alert] = "登録に失敗しました"
        render :quick_new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "画像またはタイトルを入力してください"
      render :quick_new, status: :unprocessable_entity
    end
  end

  private

  def set_item
    # まずは、自分のアイテムを探す
    @item = current_user.items.find_by(id: params[:id]) if user_signed_in?
  
    # 自分のアイテムが見つからなければ、publicなアイテムを探す
    @item ||= Item.find_by(id: params[:id], public: true)
  
    # それでも見つからなければアクセス拒否
    unless @item
      redirect_to root_path, alert: "このアイテムを見る権限がありません"
    end
  end

  def item_params
    params.require(:item).permit(
      :image, :name, :description, :brand, :category,
      :price, :color, :keyword1, :keyword2, :public,
      tag_ids: []
    )
  end

  def redirect_first_login
    return unless user_signed_in? && current_user.first_login?
  
    allowed_paths = [
      settings_path,
      destroy_user_session_path,
      welcome_path,
      how_to_path,
      quick_new_items_path
    ]

    current_path = request.path
    full_path = request.fullpath

    # URLパラメータ付きや部分一致でもOKにする
    return if allowed_paths.any? { |p| current_path.start_with?(p) || full_path.start_with?(p) }

    redirect_to settings_path
  end
end
