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
    @comment = Comment.new
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

  def search
    @keyword = params[:keyword]
    @split_keywords = params[:keyword].split(/[[:blank:]]+/)
    @items = []
    if params[:keyword] != ''
      keyword_search
    else
      @items = Item.all
    end
  end

  private

  def create_item
    params.require(:item).permit(:name, :image, :description, :category_id, :status_id, :shipping_id, :prefecture_id, :transportday_id, :price).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def user_item_check
    redirect_to root_path unless @item.buyer.nil? && current_user.id == @item.user_id
  end

  def keyword_search
    @split_keywords.each do |keyword|
      Item.where('name LIKE(?)', "%#{keyword}%").each do |answer|
        @items.push(answer)
      end
    end
  end
end
