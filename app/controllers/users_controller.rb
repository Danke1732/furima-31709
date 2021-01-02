class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :user_check

  def show
    @user_items = @user.items.includes(:buyer, :favorites).with_attached_image
    @user_favorites = @user.fav_items.includes(:buyer, :favorites).with_attached_image
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_check
    redirect_to root_path if current_user.id != @user.id
  end
end
