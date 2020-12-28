require 'rails_helper'

RSpec.describe "DeviseUsers", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @user_params = FactoryBot.attributes_for(:user)
    @invalid_user_params = FactoryBot.attributes_for(:user, nickname: '')
  end

  describe "POST registrations#create" do
    context 'パラメータが妥当な場合' do
      it "リクエストが成功すること" do
        post user_registration_path, params: { user: @user_params }
        expect(response.status).to eq 302
      end
      it "リダイレクトされること" do
        post user_registration_path, params: { user: @user_params }
        expect(response).to redirect_to root_path
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: @invalid_user_params }
        expect(response.status).to eq 200
      end
      it 'エラーが表示されること' do
        post user_registration_path, params: { user: @invalid_user_params }
        expect(response.body).to include 'ニックネームを入力してください'
      end
    end
  end

  describe 'PUT registrations#update' do
    context 'パラメータが妥当な場合' do
      it 'リクエストに成功すると正常なレスポンスが返ってくる' do
        sign_in @user
        put user_registration_path, params: { user: { nickname: "test_update", email: "test_update@test" } }
        expect(response.status).to eq 302
      end
      it 'ユーザーの情報が更新される' do
        sign_in @user
        expect do
          put user_registration_path, params: { user: { nickname: "test_update", email: "test_update@test" } }
        end.to change { User.find(@user.id).nickname }.from(@user.nickname).to('test_update')
      end
      it 'ユーザー詳細ページへリダイレクトする' do
        sign_in @user
        put user_registration_path, params: { user: { nickname: "test_update", email: "test_update@test" } }
        expect(response).to redirect_to user_path(@user)
      end
    end
  end

  describe 'GET registrations#new' do
    it 'リクエストが成功すること' do
      get new_user_registration_path
      expect(response.status).to eq 200
    end
  end

  describe 'GET sessions#new' do
    it 'リクエストが成功すること' do
      get new_user_session_path
      expect(response.status).to eq 200
    end
  end

  describe 'POST sessions#create' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post user_session_path, params: { user: { email: @user.email, password: @user.password } }
        expect(response.status).to eq 302
      end
      it 'リダイレクトされること' do
        post user_session_path, params: { user: { email: @user.email, password: @user.password } }
        expect(response).to redirect_to root_path
      end
    end
    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post user_session_path, params: { user: { email: '', password: @user.password } }
        expect(response.status).to eq 200
      end
      it 'エラーが表示されること' do
        post user_session_path, params: { user: { email: '', password: @user.password } }
        expect(response.body).to include 'Eメールまたはパスワードが違います。'
      end
    end
  end

  describe 'DELETE sessions#destroy' do
    it 'リクエストが成功すること' do
      sign_in @user
      delete destroy_user_session_path
      expect(response.status).to eq 302 
    end
    it 'リダイレクトすること' do
      sign_in @user
      delete destroy_user_session_path
      expect(response).to redirect_to root_path
    end
  end
end
