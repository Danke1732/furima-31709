require 'rails_helper'

RSpec.describe "マイページ", type: :system do
  before do
    @user = FactoryBot.create(:user_test)
    @user2 = FactoryBot.create(:user_test2)
  end

  it 'ユーザーは自分のマイページに遷移することができる' do
    # @userでログインする
    sign_in(@user)
    # ヘッダーのユーザー名からマイページの遷移するリンクがあるのを確認する
    expect(page).to have_link "#{@user.nickname}"
    # @userのマイページに移動する
    click_on "#{@user.nickname}"
    # @userの情報が記載されているのを確認する
    expect(page).to have_content(@user.nickname)
    expect(page).to have_content(@user.email)
  end
  it 'ユーザーは自分以外のユーザーマイページに遷移することができない' do
    # @user2でログインする
    sign_in(@user2)
    # @userのマイページに遷移する
    get user_path(@user)
    # トップページにリダイレクトされる
    expect(current_path).to eq root_path
  end
end
