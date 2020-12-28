require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET users#show' do
    before do
      @user = FactoryBot.create(:user_test)
    end
    context 'ログインしているとき' do
      it 'showアクションにリクエストすると正常なレスポンスが返ってくる' do
        sign_in @user
        get user_path(@user)
        expect(response.status).to eq 200
      end
      it 'showアクションにリクエストするとレスポンスにユーザー名が含まれている' do
        sign_in @user
        get user_path(@user)
        expect(response.body).to include @user.nickname
      end
      it 'showアクションにリクエストするとレスポンスにユーザーのメールアドレスが含まれている' do
        sign_in @user
        get user_path(@user)
        expect(response.body).to include @user.email
      end
    end
    context 'ログインしていないとき' do
      it 'リクエストに成功する' do
        get user_path(@user)
        expect(response.status).to eq 302
      end
      it 'ログインページにリダイレクトされる' do
        get user_path(@user)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
