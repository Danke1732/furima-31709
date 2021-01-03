require 'rails_helper'

RSpec.describe 'Transactions', type: :request do
  describe 'GET transactions#index' do
    before do
      @user = FactoryBot.create(:user_test)
      @item = FactoryBot.create(:item_test)
    end
    context 'ログインしているとき' do
      it 'indexアクションにリクエストを送ると正常なレスポンスが返ってくる' do
        sign_in @user
        get item_transactions_path(@item)
        expect(response.status).to eq 200
      end
      it 'indexアクションにリクエストを送るとレスポンスに商品名が含まれている' do
        sign_in @user
        get item_transactions_path(@item)
        expect(response.body).to include @item.name
      end
      it 'indexアクションにリクエストを送るとレスポンスに商品価格が含まれている' do
        sign_in @user
        get item_transactions_path(@item)
        expect(response.body).to include @item.price.to_s
      end
      it 'indexアクションにリクエストを送るとレスポンスに商品の発送元の負担情報が含まれている' do
        sign_in @user
        get item_transactions_path(@item)
        expect(response.body).to include @item.shipping.type
      end
      it 'indexアクションにリクエストを送るとレスポンスに商品の画像が含まれている' do
        sign_in @user
        get item_transactions_path(@item)
        expect(response.body).to include 'test-image.png'
      end
    end

    context 'ログインしていないとき' do
      it 'indexアクションにリクエストを送るとログインページへリダイレクトされる' do
        get item_transactions_path(@item)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
