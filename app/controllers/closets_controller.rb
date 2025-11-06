class ClosetsController < ApplicationController
  skip_before_action :authenticate_user!

  def share
    @items = Item.where(public: true)
                 .includes(image_attachment: :blob)
                 .order(created_at: :desc)
  end

  def show
    # 公開されているアイテムだけ表示
    @item = Item.find_by(id: params[:id], public: true)

    if @item.nil?
      redirect_to share_closet_path, alert: "このアイテムは公開されていません。"
    end
  end
end
