class FavoritesController < ApplicationController
  def like
    favorite = Favorite.find_by(item_id: params[:id], user_id: current_user.id)
    if favorite
      favorite.destroy
    else
      favorite = Favorite.new(item_id: params[:id], user_id: current_user.id)
      favorite.save
    end

    favorite_after = Favorite.find_by(item_id: params[:id], user_id: current_user.id)
    favorite_count = Favorite.where(item_id: params[:id]).count

    render json: { favorite: favorite_after, count: favorite_count }
  end
end
