class ClosetsController < ApplicationController
  skip_before_action :authenticate_user!

  def share
    @items = Item.where(public: true)
                 .includes(image_attachment: :blob) # ✅これ超大事！
                 .order(created_at: :desc)
  end
end
