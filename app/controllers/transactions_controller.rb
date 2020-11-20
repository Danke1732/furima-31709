class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :buyer_item_check

  def index
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)
    if @transaction.valid?
      item_pay
      @transaction.save
      redirect_to root_path
    else
      render action: :index
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:postal_code, :prefecture_id, :city, :address, :building, :phone_num).merge(token: params[:token], user_id: current_user.id, item_id: params[:item_id])
  end

  def item_pay
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: @item.price,
      card: transaction_params[:token],
      currency: 'jpy'
    )
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def buyer_item_check
    redirect_to root_path unless @item.buyer.nil? && current_user.id != @item.user_id
  end
end
