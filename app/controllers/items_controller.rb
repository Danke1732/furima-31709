class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(create_item)
    if @item.save
      redirect_to action: :index
    else
      render action: :new
    end
  end

  private

  def create_item
    params.require(:item).permit(:name, :image, :description, :category_id, :status_id, :shipping_id, :prefecture_id, :transportday_id, :price).merge(user_id: current_user.id)
  end
end
