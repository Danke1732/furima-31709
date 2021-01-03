require 'rails_helper'

RSpec.describe 'Favorites', type: :request do
  before do
    @user = FactoryBot.create(:user_test)
    @user2 = FactoryBot.create(:user_test2)
    @item = FactoryBot.create(:item_test)
  end

  describe 'GET favorites#like' do
    context 'ログインしているとき' do
      it 'お気に入りしていないとき、お気に入り登録ができること' do
        sign_in @user
        expect do
          get "/favorites/#{@item.id}", params: { favorite: { user_id: @user.id, item_id: @item.id } }, xhr: true
        end.to change(Favorite, :count).by(1)
      end
      it 'お気に入りしているとき、お気に入り登録を外すことできること' do
        @favorite = Favorite.create(user_id: @user.id, item_id: @item.id)
        sign_in @user
        expect do
          get "/favorites/#{@item.id}", params: { favorite: { user_id: @user.id, item_id: @item.id } }, xhr: true
        end.to change(Favorite, :count).by(-1)
      end
    end

    context 'ログインしていないとき' do
      it 'ログインページへリダイレクトする' do
        get "/favorites/#{@item.id}", params: { favorite: { user_id: @user.id, item_id: @item.id } }, xhr: true
        expect(response.body).to include 'アカウント登録もしくはログインしてください。'
      end
    end
  end
end
