require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  before do
    @user = FactoryBot.create(:user_test)
    @user2 = FactoryBot.create(:user_test2)
    @item = FactoryBot.create(:item_test)
    @comment_params = FactoryBot.attributes_for(:comment, user_id: @user.id, item_id: @item.id)
  end

  describe 'POST comments#create' do
    context 'ログインしているとき' do
      it 'リクエストを送るとコメントが登録されること' do
        sign_in @user
        expect do
          post item_comments_path(@item), params: { comment: @comment_params }, xhr: true
        end.to change(Comment, :count).by(1)
      end
    end

    context 'ログインしていないとき' do
      it 'リクエストを送るとログインページへリダイレクトされる' do
        post item_comments_path(@item), params: { comment: { text: 'test', user_id: @user.id, item_id: @item.id } }, xhr: true
        expect(response.body).to include 'アカウント登録もしくはログインしてください。'
      end
    end
  end

  describe 'DELETE comments#destroy' do
    context 'ログインしているとき' do
      it 'リクエストを送るとコメントが削除されること' do
        @comment = Comment.create(text: 'test', user_id: @user.id, item_id: @item.id)
        sign_in @user
        expect do
          delete item_comment_path(@item.id, @comment.id), xhr: true
        end.to change(Comment, :count).by(-1)
      end
    end
    context 'ログインしていないとき' do
      it 'ログインページへリダイレクトされること' do
        @comment = Comment.create(text: 'test', user_id: @user.id, item_id: @item.id)
        delete item_comment_path(@item.id, @comment.id), xhr: true
        expect(response.body).to include 'アカウント登録もしくはログインしてください。'
      end
    end
  end
end
