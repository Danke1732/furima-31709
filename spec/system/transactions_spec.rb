require 'rails_helper'

RSpec.describe "購入機能", type: :system do
  before do
    @user = FactoryBot.create(:user_test)
    @user2 = FactoryBot.create(:user_test2)
    @item = FactoryBot.create(:item_test, user_id: @user2.id)
    @transaction_params = FactoryBot.attributes_for(:transaction, user_id: @user.id, item_id: @item.id)
  end

  context '購入手続きがうまくいくとき' do
    it 'ログインしているユーザーで商品の出品者でなければ購入することができる' do
      # @userでログインする
      sign_in(@user)
      # @itemの商品詳細ページに移動する
      visit item_path(@item)
      # 商品詳細ページに「購入画面に進む」のリンクがあることを確認する
      expect(page).to have_link '購入画面に進む'
      # 商品購入手続き画面へ移動する
      click_on '購入画面に進む'
      # フォームに情報を入力する
      allow(Payjp::Charge).to receive(:create).and_return(PayjpMock.prepare_valid_charge)
      fill_in 'transaction[number]', with: '4242424242424242'
      fill_in 'transaction[exp_month]', with: '2'
      fill_in 'transaction[exp_year]', with: '22'
      fill_in 'transaction[cvc]', with: '123'
      fill_in 'transaction[postal_code]', with: @transaction_params[:postal_code]
      select '北海道', from: 'transaction[prefecture_id]'
      fill_in 'transaction[city]', with: @transaction_params[:city]
      fill_in 'transaction[address]', with: @transaction_params[:address]
      fill_in 'transaction[building]', with: @transaction_params[:building]
      fill_in 'transaction[phone_num]', with: @transaction_params[:phone_num]
      # 送信すると、Buyerモデルのカウントが1上がるのを確認する
      expect do
        find('input[name="commit"]').click
        sleep 2
      end.to change{ Buyer.count }.by(1)
      # トップページにリダイレクトする
      expect(current_path).to eq root_path
      # 購入した商品に「soldout」の表示があるのを確認する
      expect(page).to have_content 'Sold Out!!'
    end
  end
  context '購入手続きがうまくいかないとき' do
    it 'ログインしていないユーザーは商品を購入することができない' do
      # トップページにいる
      visit root_path
      # @itemの商品詳細ページに移動する
      get item_path(@item)
      # 商品詳細ページに「購入画面に進む」のリンクがないことを確認する
      expect(page).to_not have_link '購入画面に進む'
    end
    it '商品の出品者は商品を購入することはできない' do
      # @user2でログインする
      visit root_path
      # @itemの商品詳細ページに移動する
      get item_path(@item)
      # 商品詳細ページに「購入画面に進む」のリンクがないことを確認する
      expect(page).to_not have_link '購入画面に進む'
    end
  end
end
