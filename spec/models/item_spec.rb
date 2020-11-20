require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end

  describe '商品出品機能' do
    context '商品を出品がうまくいくとき' do
      it '全ての入力項目が存在すれば出品できる' do
        expect(@item).to be_valid
      end
      it 'category_idが1以外なら出品できる' do
        @item.category_id = 2
        expect(@item).to be_valid
      end
      it 'status_idが1以外なら出品できる' do
        @item.status_id = 2
        expect(@item).to be_valid
      end
      it 'shipping_idが1以外なら出品できる' do
        @item.shipping_id = 2
        expect(@item).to be_valid
      end
      it 'prefecture_idが1以外なら出品できる' do
        @item.prefecture_id = 2
        expect(@item).to be_valid
      end
      it 'transportday_idが1以外なら出品できる' do
        @item.transportday_id = 2
        expect(@item).to be_valid
      end
      it 'priceが300円以上(9999999円以下)であれば出品できる' do
        @item.price = 300
        expect(@item).to be_valid
      end
      it 'priceが9999999円以下(300円以上)であれば出品できる' do
        @item.price = 9_999_999
        expect(@item).to be_valid
      end
      it 'priceが半角数字で整数であれば出品できる' do
        @item.price = 300
        expect(@item).to be_valid
      end
    end

    context '商品を出品がうまくいかないとき' do
      it 'nameが空だと出品できない' do
        @item.name = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('商品名を入力してください')
      end
      it 'descriptionが空だと出品できない' do
        @item.description = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('商品の説明を入力してください')
      end
      it 'imageが空だと出品できない' do
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('出品画像を入力してください')
      end
      it 'category_idが1だと出品できない' do
        @item.category_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('カテゴリーを選択してください')
      end
      it 'status_idが1だと出品できない' do
        @item.status_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('商品の状態を選択してください')
      end
      it 'shipping_idが1だと出品できない' do
        @item.shipping_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('配送料の負担を選択してください')
      end
      it 'prefecture_idが1だと出品できない' do
        @item.prefecture_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('発送元の地域を選択してください')
      end
      it 'transportday_idが1だと出品できない' do
        @item.transportday_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('発送までの日数を選択してください')
      end
      it 'priceが空だと出品できない' do
        @item.price = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('価格を入力してください')
      end
      it 'priceが299円以下だと出品できない' do
        @item.price = 299
        @item.valid?
        expect(@item.errors.full_messages).to include('価格が設定金額の範囲外です')
      end
      it 'priceが10000000円以上だと出品できない' do
        @item.price = 10_000_000
        @item.valid?
        expect(@item.errors.full_messages).to include('価格が設定金額の範囲外です')
      end
      it 'priceが全角で入力されていると出品できない' do
        @item.price = '３００'
        @item.valid?
        expect(@item.errors.full_messages).to include('価格は半角数字で入力してください')
      end
      it 'priceに小数点が含まれていると出品できない' do
        @item.price = 300.000
        @item.valid?
        expect(@item.errors.full_messages).to include('価格は半角数字で入力してください')
      end
      it 'itemにuserが紐づいていないと出品できない' do
        @item.user = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('ユーザーを入力してください')
      end
    end
  end
end
