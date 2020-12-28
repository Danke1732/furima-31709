require 'rails_helper'

RSpec.describe "Items", type: :request do
  before do
    @user = FactoryBot.create(:user_test)
    @user2 = FactoryBot.create(:user_test2)
    @item = FactoryBot.create(:item_test, user_id: @user.id)
    @item2 = FactoryBot.create(:item, user_id: @user2.id)
    @invalid_item_params = FactoryBot.attributes_for(:item, name: '')
  end

  describe "GET /index" do
    context 'ログインしているとき' do
      it "リクエストに成功すること" do
        sign_in @user
        get root_path
        expect(response.status).to eq 200
      end
      it "トップページにユーザー名が含まれていること" do
        sign_in @user
        get root_path
        expect(response.body).to include @user.nickname
      end
      it "トップページにログアウトが含まれていること" do
        sign_in @user
        get root_path
        expect(response.body).to include 'ログアウト'
      end
    end
    context 'ログインしていないとき' do
      it "リクエストに成功すること" do
        get root_path
        expect(response.status).to eq 200
      end
      it "トップページに新規登録が含まれていること" do
        get root_path
        expect(response.body).to include '新規登録'
      end
      it "トップページにログインが含まれていること" do
        get root_path
        expect(response.body).to include 'ログイン'
      end
    end
  end

  describe 'GET items#new' do
    context 'ログインしているとき' do
      it 'newアクションにリクエストすると正常にレスポンスが返ってくる' do
        sign_in @user
        get new_item_path
        expect(response.status).to eq 200
      end
      it 'newアクションにリクエストするとレスポンスに「出品する」の文字が含まれている' do
        sign_in @user
        get new_item_path
        expect(response.body).to include '出品する'
      end
    end
    context 'ログインしていないとき' do
      it 'リクエストに成功する' do
        get new_item_path
        expect(response.status).to eq 302
      end
      it 'newアクションにリクエストするとログインページにリダイレクトする' do
        get new_item_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET items#show' do
    context 'ログインしているとき' do
      it 'リクエストに成功すること' do
        sign_in @user
        get item_path(@item)
        expect(response.status).to eq 200
      end
      it 'showアクションにリクエストするとレスポンスに商品の名前が含まれている' do
        sign_in @user
        get item_path(@item)
        expect(response.body).to include @item.name
      end
      it 'showアクションにリクエストするとレスポンスに商品の値段が含まれている' do
        sign_in @user
        get item_path(@item)
        expect(response.body).to include "#{@item.price}"
      end
      it 'showアクションにリクエストするとレスポンスに商品のカテゴリーが含まれている' do
        sign_in @user
        get item_path(@item)
        expect(response.body).to include @item.category.type
      end
      it 'showアクションにリクエストするとレスポンスに商品の状態が含まれている' do
        sign_in @user
        get item_path(@item)
        expect(response.body).to include @item.status.type
      end
      it 'showアクションにリクエストするとレスポンスに商品の配送料に負担が含まれている' do
        sign_in @user
        get item_path(@item)
        expect(response.body).to include @item.shipping.type
      end
      it 'showアクションにリクエストするとレスポンスに発送元の地域が含まれている' do
        sign_in @user
        get item_path(@item)
        expect(response.body).to include @item.prefecture.type
      end
      it 'showアクションにリクエストするとレスポンスに発送日に目安が含まれている' do
        sign_in @user
        get item_path(@item)
        expect(response.body).to include @item.transportday.type
      end
      it 'showアクションにリクエストするとレスポンスにお気に入りが含まれている' do
        sign_in @user
        get item_path(@item)
        expect(response.body).to include 'お気に入り'
      end
      it 'showアクションにリクエストするとレスポンスに「コメント一覧」が含まれている' do
        sign_in @user
        get item_path(@item)
        expect(response.body).to include 'コメント一覧'
      end
      it '投稿者でログインしてshowアクションにリクエストするとレスポンスに編集、削除が含まれている' do
        sign_in @user
        get item_path(@item)
        expect(response.body).to include '編集'
        expect(response.body).to include '削除'
      end
      it '投稿者以外がログインしてshowアクションにリクエストするとレスポンスに「購入画面に進む」が含まれている' do
        sign_in @user2
        get item_path(@item)
        expect(response.body).to include '購入画面に進む'
      end
    end
    context 'ログインしていないとき' do
      it 'リクエストに成功すること' do
        get item_path(@item)
        expect(response.status).to eq 200
      end
      it 'showアクションにリクエストすると「コメント一覧」が含まれていない' do
        get item_path(@item)
        expect(response.body).to_not include 'コメント一覧'
      end
      it 'showアクションにリクエストすると「お気に入り」が含まれていない' do
        get item_path(@item)
        expect(response.body).to_not include 'お気に入り'
      end
    end
  end

  describe 'GET items#edit' do
    context 'ログインしているとき' do
      before do
        sign_in @user
      end
      it 'editアクションにリクエストすると正常にレスポンスが返ってくる' do
        get edit_item_path(@item)
        expect(response.status).to eq 200
      end
      it 'editアクションにリクエストするとすでに商品の名前が存在する' do
        get edit_item_path(@item)
        expect(response.body).to include "#{@item.name}"
      end
      it 'editアクションにリクエストするとすでに商品の説明が存在する' do
        get edit_item_path(@item)
        expect(response.body).to include @item.description
      end
      it 'editアクションにリクエストするとすでに商品のカテゴリーが存在する' do
        get edit_item_path(@item)
        expect(response.body).to include @item.category.type
      end
      it 'editアクションにリクエストするとすでに商品の画像が存在する' do
        get edit_item_path(@item)
        expect(response.body).to include "test-image.png"
      end
      it 'editアクションにリクエストするとすでに商品の状態が存在する' do
        get edit_item_path(@item)
        expect(response.body).to include @item.status.type
      end
      it 'editアクションにリクエストするとすでに商品の配送料に負担が存在する' do
        get edit_item_path(@item)
        expect(response.body).to include @item.shipping.type
      end
      it 'editアクションにリクエストするとすでに商品の発送元の負担が存在する' do
        get edit_item_path(@item)
        expect(response.body).to include @item.prefecture.type
      end
      it 'editアクションにリクエストするとすでに商品の発送までの日数が存在する' do
        get edit_item_path(@item)
        expect(response.body).to include "#{@item.transportday.type}"
      end
      it 'editアクションにリクエストするとすでに商品の価格が存在する' do
        get edit_item_path(@item)
        expect(response.body).to include "#{@item.price}"
      end
      it '出品者以外がeditアクションにリクエストするとトップページにリダイレクトする' do
        get edit_item_path(@item2)
        expect(response).to redirect_to root_path 
      end
    end
    context 'ログインしていないとき' do
      it 'リクエストに成功する' do
        get edit_item_path(@item)
        expect(response.status).to eq 302
      end
      it 'editアクションにリクエストするとログインページにリダイレクトする' do
        get edit_item_path(@item)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST item#create' do
    before do
      sign_in @user
      @item_params = FactoryBot.attributes_for(:item_test, image: fixture_file_upload('public/images/test-image.png'), user_id: @user.id )
    end
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すると正常なレスポンスが返ってくること' do
        post items_path, params: { item: @item_params }
        expect(response.status).to eq 302
      end
      it '商品が登録されること' do
        expect do
          post items_path, params: { item: @item_params }
        end.to change(Item, :count).by(1)
      end
      it 'トップページにリダイレクトすること' do
        post items_path, params: { item: @item_params }
        expect(response).to redirect_to root_path
      end
    end
    context 'パラメータが不正な場合' do
      before do
        sign_in @user
      end
      it 'リクエストが成功すると正常なレスポンスが返ってくること' do
        post items_path, params: { item: @invalid_item_params, user_id: @user.id }
        expect(response.status).to eq 200
      end
      it '商品が登録されないこと' do
        expect do
          post items_path, params: { item: @invalid_item_params, user_id: @user.id }
        end.to change(Item, :count).by(0)
      end
      it 'エラーが表示されること' do
        post items_path, params: { item: @invalid_item_params, user_id: @user.id }
        expect(response.body).to include '商品名を入力してください'
      end
    end
  end

  describe 'PATCH items#update' do
    context 'パラメータが妥当なとき' do
      before do
        sign_in @user
        @item_params = FactoryBot.attributes_for(:item_test2, image: fixture_file_upload('public/images/test-image2.jpg'), user_id: @user.id)
      end
      it 'リクエストに成功すると正常なレスポンスが返ってくること' do
        patch item_path(@item), params: { item: @item_params }
        expect(response.status).to eq 302
      end
      it '商品の内容が更新されること' do
        expect do
          patch item_path(@item), params: { item: @item_params }
        end.to change { Item.find(@item.id).name }.from(@item.name).to('test2')
      end
      it 'トップページへリダイレクトされること' do
        patch item_path(@item), params: { item: @item_params }
        expect(response).to redirect_to item_path(@item)
      end
    end
    context 'パラメータが不正なとき' do
      before do
        sign_in @user
        @item_params = FactoryBot.attributes_for(:item_test2, name: '', image: fixture_file_upload('public/images/test-image2.jpg'), user_id: @user.id)
      end
      it 'リクエストに成功すると正常なレスポンスが返ってくること' do
        patch item_path(@item), params: { item: @item_params }
        expect(response.status).to eq 200
      end
      it '商品の内容が更新されないこと' do
        expect do
          patch item_path(@item), params: { item: @item_params }
        end.to_not change(Item.find(@item.id), :name)
      end
      it 'エラーが表示されること' do
        patch item_path(@item), params: { item: @item_params }
        expect(response.body).to include '商品名を入力してください'
      end
    end
  end

  describe 'DELETE items#destroy' do
    before do
      sign_in @user
    end
    it 'リクエストが成功すること' do
      delete item_path(@item)
      expect(response.status).to eq 302
    end
    it '商品が削除されること' do
      expect do
        delete item_path(@item)
      end.to change(Item, :count).by(-1)
    end
    it 'トップページへリダイレクトされること' do
      delete item_path(@item)
      expect(response).to redirect_to root_path
    end
  end
end
