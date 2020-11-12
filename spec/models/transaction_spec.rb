require 'rails_helper'

RSpec.describe Transaction, type: :model do
  before do
    @transaction = FactoryBot.build(:transaction)
  end

  describe '商品購入機能' do
    context '商品購入ができるとき' do
      it '全ての入力項目が存在すれば購入できる' do
        expect(@transaction).to be_valid
      end
      it 'postal_codeが半角数字3桁-半角数字4桁で入力されれば購入できる' do
        @transaction.postal_code = '123-4567'
        expect(@transaction).to be_valid
      end
      it 'prefecture_idが1以外なら購入できる' do
        @transaction.prefecture_id = 2
        expect(@transaction).to be_valid
      end
      it 'buildingが空でも購入できる' do
        @transaction.building = nil
        expect(@transaction).to be_valid
      end
      it 'phone_numがハイフンなしの半角数字11桁以内なら登録できる' do
        @transaction.phone_num = '09012345678'
        expect(@transaction).to be_valid
      end
    end
    context '商品購入ができないとき' do
      it 'tokenが空だと購入できない' do
        @transaction.token = nil
        @transaction.valid?
        expect(@transaction.errors.full_messages).to include("Token can't be blank")
      end
      it 'postal_codeが空だと購入できない' do
        @transaction.postal_code = nil
        @transaction.valid?
        expect(@transaction.errors.full_messages).to include("Postal code can't be blank")
      end
      it 'prefecture_idが1だと購入できない' do
        @transaction.prefecture_id = 1
        @transaction.valid?
        expect(@transaction.errors.full_messages).to include('Prefecture Select')
      end
      it 'cityが空だと購入できない' do
        @transaction.city = nil
        @transaction.valid?
        expect(@transaction.errors.full_messages).to include("City can't be blank")
      end
      it 'addressが空だと購入できない' do
        @transaction.address = nil
        @transaction.valid?
        expect(@transaction.errors.full_messages).to include("Address can't be blank")
      end
      it 'phone_numが空だと購入できない' do
        @transaction.phone_num = nil
        @transaction.valid?
        expect(@transaction.errors.full_messages).to include("Phone num can't be blank")
      end
      it 'postal_codeが半角のハイフンを含んだ正しい形式でないと購入できない' do
        @transaction.postal_code = '1234567'
        @transaction.valid?
        expect(@transaction.errors.full_messages).to include('Postal code Input correctly')
      end
      it 'phone_numが全角で入力されると購入できない' do
        @transaction.phone_num = '０８０１２３４５６７８'
        @transaction.valid?
        expect(@transaction.errors.full_messages).to include('Phone num Input only number')
      end
      it 'phone_numが半角数字以外が入力されると購入できない' do
        @transaction.phone_num = 'abcdefghijk'
        @transaction.valid?
        expect(@transaction.errors.full_messages).to include('Phone num Input only number')
      end
      it 'phone_numにハイフンが含まれると購入できない' do
        @transaction.phone_num = '090-1234-5678'
        @transaction.valid?
        expect(@transaction.errors.full_messages).to include('Phone num Input only number')
      end
      it 'phone_numが12桁以上だと購入できない' do
        @transaction.phone_num = '090123456789'
        @transaction.valid?
        expect(@transaction.errors.full_messages).to include('Phone num Input only number')
      end
    end
  end
end
