require 'rails_helper'

RSpec.describe 'お気に入り', type: :system do
  before do
    @user = FactoryBot.create(:user_test)
    @user2 = FactoryBot.create(:user_test2)
    @item = FactoryBot.create(:item_test, user_id: @user2.id)
  end

  context 'お気に入り登録ができるとき' do
    it 'ログインしているユーザーであればお気に入り登録ができる' do
      # @userでログインする
      sign_in(@user)
      # @itemの商品詳細ページに移動する
      visit item_path(@item)
      # 「お気に入り」ボタンの存在を確認する
      expect(page).to have_content 'お気に入り'
      sleep 2
      # 送信すると、Favoriteモデルのカウントが1上がるのを確認する
      expect do
        find('.favorite-btn').click
        sleep 1
      end.to change { Favorite.count }.by(1)
    end
  end

  context 'お気に入り登録ができないとき' do
    it 'ログインしていないユーザーはお気に入り登録ができない' do
      # @itemの商品詳細ページへ移動する
      visit item_path(@item)
      # お気に入りボタンがないことを確認する
      expect(page).to_not have_content 'お気に入り'
    end
  end
end
