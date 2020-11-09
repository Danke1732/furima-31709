class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :user_item_check, only: [:edit, :update, :destroy]

  def index
    @items = Item.includes(:user).order('created_at DESC')
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

  def show
  end

  def edit
  end

  def update
    if @item.update(create_item)
      redirect_to action: :show
    else
      render action: :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to action: :index
  end

  private

  def create_item
    params.require(:item).permit(:name, :image, :description, :category_id, :status_id, :shipping_id, :prefecture_id, :transportday_id, :price).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def user_item_check
    unless @item.buyer.nil? && current_user.id == @item.user_id 
      redirect_to root_path
    end
  end
end
