class ClosetsController < ApplicationController
  skip_before_action :authenticate_user!

  def share
    @items = Item.where(public: true).order(created_at: :desc)
  end
end