require 'rails_helper'

RSpec.describe "商品出品", type: :system do
  before do
    @user = FactoryBot.create(:user_test)
    @item_image = Rails.root.join('public/images/test-image.png')
    @item = FactoryBot.attributes_for(:item, user_id: @user.id)
  end

  context '商品の出品ができるとき' do
    it 'ログインしたユーザーは商品を出品することができる' do
      # ログインする
      sign_in(@user)
      # 新規投稿ページへのリンクがある
      expect(page).to have_content '新規投稿商品'
      # 出品商品情報入力ページへ移動する
      click_on '新規投稿商品'
      # フォームに情報を入力する
      attach_file('item[image]', @item_image, make_visible: true)
      fill_in 'item[name]', with: @item[:name]
      fill_in 'item[description]', with: @item[:description]
      select 'レディース', from: 'item[category_id]'
      select '新品、未使用', from: 'item[status_id]'
      select '着払い(購入者負担)', from: 'item[shipping_id]'
      select '北海道', from: 'item[prefecture_id]'
      select '1~2日で発送', from: 'item[transportday_id]'
      fill_in 'item[price]', with: 500
      # 送信するとItemモデルのカウントが1上がる
      expect do
        find('input[name="commit"]').click
      end.to change{ Item.count }.by(1)
      # トップページに遷移する
      expect(current_path).to eq root_path
      # トップページには先ほど出品した商品が存在する(商品名)
      expect(page).to have_content(@item[:name])
      # トップページには先ほど出品した商品が存在する(商品価格)
      expect(page).to have_content '500'
      # トップページには先ほど出品した商品が存在する(shippingタイプ)
      expect(page).to have_content(@item[:shipping])
    end
  end
  context '商品の出品ができないとき' do
    it 'ログインしていないと出品商品情報入力ページに遷移することができない' do
      # トップページに遷移する
      visit root_path
      # 新規投稿ページのリンクがある
      expect(page).to have_content '新規投稿商品'
      # 新規投稿ページのリンクを押す
      click_on '新規投稿商品'
      # ログインページ戻される
      expect(current_path).to eq new_user_session_path
    end
  end
end

RSpec.describe '出品商品編集', type: :system do
  before do
    @user = FactoryBot.create(:user_test)
    @user2 = FactoryBot.create(:user_test2)
    @item = FactoryBot.create(:item_test, user_id: @user.id)
    @item2 = FactoryBot.create(:item_test, user_id: @user2.id)
    @item_image2 = Rails.root.join('public/images/test-image2.jpg')
    @item_update = FactoryBot.attributes_for(:item_test2)
  end

  context '出品商品の編集ができるとき' do
    it 'ログインしているユーザーは自分の出品した商品を編集することができる' do
      # @userでログインする
      sign_in(@user)
      # @itemが存在する
      expect(page).to have_content(@item.name)
      expect(page).to have_content(@item.price)
      expect(page).to have_content(@item.shipping.type)
      # @itemの商品詳細ページへ移動する
      visit item_path(@item)
      # 商品詳細ページに「商品の編集」リンクが存在する
      expect(page).to have_link '商品の編集'
      # 商品編集ページへ移動する
      click_on '商品の編集'
      # 商品編集ページにはすでに出品している商品の内容がフォーム内に入力されている
      expect(find('.review-image')['src']).to include 'test-image.png'
      expect(find('#item-name').value).to eq @item.name
      expect(find('#item-info').value).to eq @item.description
      expect(page).to have_select('item[category_id]', selected: 'レディース')
      expect(page).to have_select('item[status_id]', selected: '新品、未使用')
      expect(page).to have_select('item[shipping_id]', selected: '着払い(購入者負担)')
      expect(page).to have_select('item[prefecture_id]', selected: '北海道')
      expect(page).to have_select('item[transportday_id]', selected: '1~2日で発送')
      expect(find('#item-price').value).to eq "#{@item.price}"
      # 商品の内容を編集する
      attach_file('item[image]', @item_image2, make_visible: true)
      fill_in 'item[name]', with: @item_update[:name]
      fill_in 'item[description]', with: @item_update[:description]
      select 'メンズ', from: 'item[category_id]'
      select '未使用に近い', from: 'item[status_id]'
      select '送料込み(出品者負担)', from: 'item[shipping_id]'
      select '青森', from: 'item[prefecture_id]'
      select '2~3日で発送', from: 'item[transportday_id]'
      fill_in 'item[price]', with: 1000
      # 編集してもItemモデルのカウントが変わらないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change{ Item.count }.by(0)
      # トップページに遷移する
      expect(current_path).to eq item_path(@item)
      # トップページには先ほど変更した商品が存在する(商品名)
      expect(page).to have_content(@item_update[:name])
      # トップページには先ほど変更した商品が存在する(商品価格)
      expect(page).to have_content '1000'
      # トップページには先ほど変更した商品が存在する(shippingタイプ)
      expect(page).to have_content '2~3日で発送'
      # トップページには先ほど変更した商品が存在する(カテゴリー)
      expect(page).to have_content 'メンズ'
      # トップページには先ほど変更した商品が存在する(商品の状態)
      expect(page).to have_content '未使用に近い'
      # トップページには先ほど変更した商品が存在する(発送元の地域)
      expect(page).to have_content '青森'
    end
  end
  context '出品商品の編集ができないとき' do
    it 'ログインしたユーザーは自分以外の出品商品を編集することができない' do
      # @userでログインする
      sign_in(@user)
      # @item2(投稿者は@user2)が存在している
      expect(page).to have_content(@item2.name)
      expect(page).to have_content(@item2.price)
      expect(page).to have_content(@item2.shipping.type)
      # @item2の商品詳細ページへ移動する
      visit item_path(@item2)
      # 商品詳細ページに「商品の編集」リンクがないことを確認する
      expect(page).to_not have_link '商品の編集'
    end
    it 'ログインしていないと出品商品を編集することができない' do
      # トップページにいる
      visit root_path
      # @itemの記事詳細ページへ遷移する
      visit item_path(@item)
      # @itemの商品詳細ページに「商品の編集」リンクがないことを確認する
      expect(page).to_not have_link '商品の編集'
      # トップページにいる
      visit root_path
      # @item2の記事詳細ページへ遷移する
      visit item_path(@item2)
      # @itemの商品詳細ページに「商品の編集」リンクがないことを確認する
      expect(page).to_not have_link '商品の編集'
    end
  end
end

RSpec.describe '商品削除', type: :system do
  before do
    @user = FactoryBot.create(:user_test)
    @user2 = FactoryBot.create(:user_test2)
    @item = FactoryBot.create(:item_test, user_id: @user.id)
    @item2 = FactoryBot.create(:item_test2, name: "update", price: 500, shipping_id: 3, user_id: @user2.id)
  end

  context '商品を削除できるとき' do
    it 'ログインしているユーザーは自分が出品した商品を削除することができる' do
      # @userでログインする
      sign_in(@user)
      # @itemが存在する
      expect(page).to have_content(@item.name)
      expect(page).to have_content(@item.price)
      expect(page).to have_content(@item.shipping.type)
      # @itemの商品詳細ページへ移動する
      visit item_path(@item)
      # 商品詳細ページには「削除」リンクが存在する
      expect(page).to have_link '削除'
      # 商品を削除するとItemモデルのカウントが1下がるのを確認する
      expect do
        click_on '削除'
      end.to change{ Item.count }.by(-1)
      # トップページに遷移する
      expect(current_path).to eq root_path
      # トップページに先ほど削除した商品がないことを確認する(商品名)
      expect(page).to_not have_content('test')
      # トップページに先ほど削除した商品がないことを確認する(商品価格)
      expect(page).to_not have_content(@item.price)
      # トップページに先ほど削除した商品がないことを確認する(shippingタイプ)
      expect(page).to_not have_content(@item.shipping.type)
    end
  end
  context '商品を削除できないとき' do
    it 'ログインしているユーザーは自分以外が出品した商品を削除することができない' do
      # @userでログインする
      sign_in(@user)
      # @item2が存在する
      expect(page).to have_content(@item2.name)
      expect(page).to have_content(@item2.price)
      expect(page).to have_content(@item2.shipping.type)
      # @item2の商品詳細ページに移動する
      visit item_path(@item2)
      # 商品詳細ページに「削除」リンクがないことを確認する
      expect(page).to_not have_link '削除'
    end

    it 'ログインしていないと商品を削除することはできない' do
      # トップページに存在する
      visit root_path
      # @itemの商品詳細ページへ移動する
      visit item_path(@item)
      # @itemの商品詳細ページに「削除」リンクがないことを確認する
      expect(page).to_not have_link '削除'
      # トップページに存在する
      visit root_path
      # @item2の商品詳細ページへ移動する
      visit item_path(@item2)
      # @item2の商品詳細ページに「削除」リンクがないことを確認する
      expect(page).to_not have_link '削除'
    end
  end
end

RSpec.describe '商品詳細' , type: :system do
  before do
    @user = FactoryBot.create(:user_test)
    @user2 = FactoryBot.create(:user_test2)
    @item = FactoryBot.create(:item_test, user_id: @user2.id)
  end

  context 'ログインしているとき' do
    it 'ログインしているユーザーは記事詳細ページに遷移すると「コメントする」ボタンが表示される' do
      # @userでログインする
      sign_in(@user)
      # @itemが存在する
      expect(page).to have_content(@item.name)
      expect(page).to have_content(@item.price)
      expect(page).to have_content(@item.shipping.type)
      # @itemの商品詳細ページへ移動する
      visit item_path(@item)
      # @itemの商品詳細ページに「コメントする」のボタンが存在するのを確認する
      expect(page).to have_button 'コメントする'
    end
    it 'ログインしているユーザーで自分が投稿した記事以外の記事詳細ページに遷移すると「お気に入り」ボタンが表示される' do
      # @userでログインする
      sign_in(@user)
      # @itemが存在する
      expect(page).to have_content(@item.name)
      expect(page).to have_content(@item.price)
      expect(page).to have_content(@item.shipping.type)
      # @itemの商品詳細ページへ移動する
      visit item_path(@item)
      # @itemの商品詳細ページに「お気に入り」リンクが存在するのを確認する
      expect(page).to have_content 'お気に入り'
    end
  end
  context 'ログインしていないとき' do
    it '商品詳細ページに遷移すると、コメント一覧が存在しないこと' do
      # トップページにいる
      visit root_path
      # @itemが存在する
      expect(page).to have_content(@item.name)
      expect(page).to have_content(@item.price)
      expect(page).to have_content(@item.shipping.type)
      # @itemの商品詳細ページへ移動する
      visit item_path(@item)
      # 商品詳細ページに「コメントする」ボタンが存在しないこと確認する
      expect(page).to_not have_button 'コメントする'
    end
    it '商品詳細ページに遷移すると、お気に入りリンクが存在しないこと' do
      # トップページにいる
      visit root_path
      # @itemが存在する
      expect(page).to have_content(@item.name)
      expect(page).to have_content(@item.price)
      expect(page).to have_content(@item.shipping.type)
      # @itemの商品詳細ページへ移動する
      visit item_path(@item)
      # 商品詳細ページに「お気に入り」が存在しないこと確認する
      expect(page).to_not have_content 'お気に入り'
    end
  end
end

RSpec.describe '商品検索', type: :system do
  before do
    @user = FactoryBot.create(:user_test)
    @user2 = FactoryBot.create(:user_test2)
    @item = FactoryBot.create(:item_test, user_id: @user.id)
    @item2 = FactoryBot.create(:item_test2, user_id: @user2.id)
  end

  it '検索欄から商品名に合致する項目があれば検索結果に表示される' do
    # トップページにいる
    visit root_path
    # 商品名を検索する
    fill_in 'keyword', with: 'test'
    find('.search-button').click
    # 検索結果ページに遷移する
    expect(current_path).to eq search_items_path
    # 検索欄に入力した文字列に合う商品名が表示される
    # @item
    expect(page).to have_content(@item.name)
    expect(page).to have_content(@item.price)
    expect(page).to have_content(@item.shipping.type)
    # @item2
    expect(page).to have_content(@item2.name)
    expect(page).to have_content(@item2.price)
    expect(page).to have_content(@item2.shipping.type)
  end
end

RSpec.describe '商品詳細ページ切り替え', type: :system do
  before do
    @user = FactoryBot.create(:user_test)
    @user2 = FactoryBot.create(:user_test2)
    @item = FactoryBot.create(:item_test, user_id: @user.id)
    @item2 = FactoryBot.create(:item_test2, user_id: @user2.id)
    @item3 = FactoryBot.create(:item_test2, user_id: @user2.id)
  end
  it '商品詳細ページの下部の「前の商品」を選択すると一つ前の商品idの詳細ページに移動する' do
    # トップページにいる
    visit root_path
    # @item2の商品詳細ページに移動する
    visit item_path(@item2)
    # @item2の商品詳細ページに「< 前の商品」のリンクがある
    expect(page).to have_link '< 前の商品'
    # 「< 前の商品」をクリックすると、@itemの商品詳細ページにいることを確認する
    click_on '< 前の商品'
    expect(current_path).to eq item_path(@item)
    # item.idが最初の状態だと「< 前の商品」のリンクが表示されないことを確認する
    expect(page).to_not have_link '< 前の商品'
  end
  it '商品詳細ページの下部の「後ろの商品」を選択すると一つ後の商品idの詳細ページに移動する' do
    # トップページにいる
    visit root_path
    # @item2の商品詳細ページに移動する
    visit item_path(@item2)
    # @item2の商品詳細ページに「後ろの商品 >」のリンクがある
    expect(page).to have_link '後ろの商品 >'
    # 「後ろの商品 >」をクリックすると、@item3の商品詳細ページにいることを確認する
    click_on '後ろの商品 >'
    expect(current_path).to eq item_path(@item3)
    # item.idが最初の状態だと「後ろの商品 >」のリンクが表示されないことを確認する
    expect(page).to_not have_link '後ろの商品 >'
  end
end