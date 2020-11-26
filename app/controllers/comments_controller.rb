class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, only: [:update, :destroy]

  def create
    @item = Item.find(params[:item_id])
    @comment = Comment.new(comment_params)
    if @comment.valid?
      @comment.save
      comment = Comment.where(user_id: current_user.id, item_id: params[:item_id]).last
      render json: { comment: comment, user: current_user }
    else
      error_message = @comment.errors.full_messages
      render json: { error: error_message }
    end
    
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy
    comment = Comment.find_by(id: params[:id])
    render json: { comment: comment }
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, item_id: params[:item_id])
  end
end
