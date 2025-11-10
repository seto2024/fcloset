class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_first_login, except: [:quick_new, :quick_create]
  before_action :set_item, only: [:show, :edit, :update, :destroy, :remove_white_bg]

  def index
    @items = current_user.items
    
    if params[:tag_id].present?
      @items = @items.joins(:tags).where(tags: { id: params[:tag_id] }).distinct
    end  

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

    @tags = Tag.all
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

  require "mini_magick"

  def remove_white_bg
    @item = Item.find(params[:id])

    if @item.image.attached?
      # ActiveStorageの実ファイルパスを取得
      image_path = ActiveStorage::Blob.service.path_for(@item.image.key)

      # 出力ファイルの一時保存先
      output_path = Rails.root.join("tmp", "removed_bg_#{SecureRandom.hex(4)}.png")

      image = MiniMagick::Image.open(image_path)
      image.format "png"
      image.colorspace "RGB"

      # 白背景を透過（fuzzは透過の“許容範囲”）
      image.fuzz "15%"
      image.transparent "white"

      image.write(output_path)

      # 古い画像を削除して新しい透過画像を保存
      @item.image.purge
      @item.image.attach(
        io: File.open(output_path),
        filename: "removed_bg.png",
        content_type: "image/png"
      )

      redirect_to @item, notice: "背景を透過しました！"
    else
      redirect_to @item, alert: "画像がありません。"
    end
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

  def set_tags
    @tags = Tag.all
  end

  def set_item
    if action_name == 'show'
      # showアクションだけは公開アイテムも見られる
      @item = current_user&.items&.find_by(id: params[:id]) || Item.find_by(id: params[:id], public: true)
    else
      # それ以外のアクションは自分のアイテムのみ操作可能
      @item = current_user.items.find_by(id: params[:id])
    end
  
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
