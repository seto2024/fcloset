class ClosetsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :share]
  skip_before_action :redirect_first_login, only: [:share, :show]

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
      return
    end
  end
end
