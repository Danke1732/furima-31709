require 'rails_helper'

RSpec.describe 'コメント投稿', type: :system do
  before do
    @user = FactoryBot.create(:user_test)
    @user2 = FactoryBot.create(:user_test2)
    @item = FactoryBot.create(:item_test, user_id: @user.id)
    @comment_text = Faker::Lorem.characters(number: 50)
  end

  context 'コメント投稿ができるとき' do
    it 'ログインしているユーザーはコメント投稿することができる' do
      # @userでログインする
      sign_in(@user)
      # @itemの商品詳細ページに移動する
      visit item_path(@item)
      # コメント投稿フォームの存在を確認する
      expect(page).to have_button 'コメントする'
      # フォームへ内容を入力する
      fill_in 'comment[text]', with: @comment_text
      # 送信するとCommentモデルのカウントが1上がる
      expect do
        find('.comment-btn').click
      end.to change { Comment.count }.by(1)
      # コメント一覧に入力した内容のコメントが表示される
      expect(page).to have_content(@comment_params)
    end
  end
  context 'コメント投稿ができないとき' do
    it 'ログインしていないユーザーはコメントを投稿することができない' do
      # トップページにいる
      visit root_path
      # @itemの商品詳細ページに移動する
      visit item_path(@item)
      # コメント投稿フォームが存在しないことを確認
      expect(page).to_not have_selector('#comment_text')
    end
  end
end

RSpec.describe 'コメント削除', type: :system do
  before do
    @user = FactoryBot.create(:user_test)
    @user2 = FactoryBot.create(:user_test2)
    @user3 = FactoryBot.create(:user_test2)
    @item = FactoryBot.create(:item_test, user_id: @user2.id)
    @comment = FactoryBot.create(:comment, item_id: @item.id, user_id: @user.id)
  end

  context 'コメント削除ができるとき' do
    it 'ログインしているコメントの投稿者は自分のコメントを削除することができる' do
      # @userでログインする
      sign_in(@user)
      # @itemの記事詳細ページに移動する
      visit item_path(@item)
      # @commentが投稿されていて、削除ボタンがあるのを確認する
      expect(page).to have_content(@comment.text)
      expect(page).to have_selector('.comment-delete')
      # 削除ボタンを押して送信後、Commentモデルのカウントが1下がるのを確認する
      sleep 2
      find('.comment-delete').click
      # コメントが存在していないのを確認する
      expect(page).to_not have_content(@comment.text)
    end
    it 'ログインしている商品の投稿者はコメントを削除することができる' do
      # @user2でログインする
      sign_in(@user2)
      # @itemの商品詳細ページに移動する
      visit item_path(@item)
      # @commentが投稿されていて、削除ボタンがあるのを確認する
      expect(page).to have_content(@comment.text)
      expect(page).to have_selector('.comment-delete')
      # 削除ボタンを押して送信後、Commentモデルのカウントが1下がるのを確認する
      sleep 2
      find('.comment-delete').click
      # コメントが存在していないのを確認する
      expect(page).to_not have_content(@comment.text)
    end
  end
  context 'コメント削除ができないとき' do
    it 'ログインしていないユーザーはコメントを削除することができない' do
      # トップページにいる
      visit root_path
      # @itemの商品詳細ページへ移動する
      visit item_path(@item)
      # コメント一覧が表示されていないのを確認する
      expect(page).to_not have_selector('#all-comments')
    end
    it 'ログインしているユーザーは自分以外のコメントを削除することはできない' do
      # @user3でログインする
      sign_in(@user3)
      # @itemの商品詳細ページへ移動する
      visit item_path(@item)
      # @commentが投稿されているのを確認する
      expect(page).to have_content(@comment.text)
      # コメントに削除ボタンがないことを確認する
      expect(page).to_not have_selector('.comment-delete')
    end
  end
end
