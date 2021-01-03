require 'rails_helper'

RSpec.describe '新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user_test)
  end

  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すれば新規登録ができて、トップページに戻る' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するリンクがある
      expect(page).to have_content '新規登録'
      # 新規登録ページに移動する
      click_on '新規登録'
      # ユーザー情報を入力する
      fill_in 'ニックネーム', with: @user.nickname
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード', with: @user.password
      fill_in 'パスワード(確認)', with: @user.password_confirmation
      fill_in 'user[last_name]', with: @user.last_name
      fill_in 'user[first_name]', with: @user.first_name
      fill_in 'user[last_name_katakana]', with: @user.last_name_katakana
      fill_in 'user[first_name_katakana]', with: @user.first_name_katakana
      select '2000', from: 'user[birth_date(1i)]'
      select '2', from: 'user[birth_date(2i)]'
      select '22', from: 'user[birth_date(3i)]'
      # サインアップボタンを押すとユーザーモデルのカウントが1上がる
      expect do
        find('input[name="commit"]').click
      end.to change { User.count }.by(1)
      # トップページへ遷移する
      expect(current_path).to eq root_path
      # ログアウトボタンが表示されている
      expect(page).to have_link 'ログアウト'
      # サインアップページに遷移するリンクやログインページに遷移するボタンが表示されていない
      expect(page).to_not have_link '新規登録'
      expect(page).to_not have_link 'ログイン'
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報を入力すれば新規登録ができず、新規登録ページに戻る' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページに遷移するリンクがある
      expect(page).to have_content '新規登録'
      # 新規登録ページに移動する
      click_on '新規登録'
      # ユーザー情報を入力する
      fill_in 'ニックネーム', with: ''
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      fill_in 'パスワード(確認)', with: ''
      fill_in 'user[last_name]', with: ''
      fill_in 'user[first_name]', with: ''
      fill_in 'user[last_name_katakana]', with: ''
      fill_in 'user[first_name_katakana]', with: ''
      # select '', from: 'user[birth_date(1i)]'
      # select '', from: 'user[birth_date(2i)]'
      # select '', from: 'user[birth_date(3i)]'
      # サインアップボタンを押してもユーザーモデルのカウントは上がらない
      expect do
        find('input[name="commit"]').click
      end.to change { User.count }.by(0)
      # 新規登録ページに戻される
      expect(current_path).to eq '/users'
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログインできるとき' do
    it '保存されているユーザーの情報と合致すればログインできる' do
      # トップページへ移動する
      visit root_path
      # トップページにログインページへの遷移リンクがある
      expect(page).to have_content 'ログイン'
      # ログインページへ移動する
      click_on 'ログイン'
      # 正しいユーザー情報を入力する
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページに遷移する
      expect(current_path).to eq root_path
      # ログアウトボタンが表示されている
      expect(page).to have_link 'ログアウト'
      # サインアップページに遷移するボタンやログインページに遷移するボタンが表示されていない
      expect(page).to_not have_link '新規登録'
      expect(page).to_not have_link 'ログイン'
    end
  end
  context 'ログインできないとき' do
    it '保存されているユーザーの情報と合致しなければログインできない' do
      # トップページに移動する
      visit root_path
      # トップページにログインページに遷移するボタンがある
      expect(page).to have_content 'ログイン'
      # ログインページに移動する
      click_on 'ログイン'
      # 誤った情報を入力する
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページに戻される
      expect(current_path).to eq new_user_session_path
    end
  end
end
