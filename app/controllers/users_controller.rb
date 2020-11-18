class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :user_check

  def show
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_check
    if current_user.id != @user.id
      redirect_to root_path
    end
  end
end