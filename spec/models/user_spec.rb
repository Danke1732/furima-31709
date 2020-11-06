require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context 'ユーザー新規登録がうまくいくとき' do
      it '全ての入力項目が存在していれば登録できる' do
        expect(@user).to be_valid
      end
      it 'passwordが6文字以上であれば登録できる' do
        @user.password = 'aaa000'
        @user.password_confirmation = 'aaa000'
        expect(@user).to be_valid
      end
      it 'passwordに英字と数字両方が含まれていれば登録できる' do
        @user.password = 'aaa000'
        @user.password_confirmation = 'aaa000'
        expect(@user).to be_valid
      end
      it 'last_nameが全角入力であれば登録できる' do
        @user.last_name = '田中'
        expect(@user).to be_valid
      end
      it 'first_nameが全角入力であれば登録できる' do
        @user.first_name = '太郎'
        expect(@user).to be_valid
      end
      it 'last_name_katakanaが全角入力であれば登録できる' do
        @user.last_name_katakana = 'タナカ'
        expect(@user).to be_valid
      end
      it 'first_name_katakanaが全角入力であれば登録できる' do
        @user.first_name_katakana = 'タロウ'
        expect(@user).to be_valid
      end
    end

    context 'ユーザー登録がうまくいかないとき' do
      it 'nicknameが空だと登録できない' do
        @user.nickname = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end
      it 'emailが空だと登録できない' do
        @user.email = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end
      it 'passwordが空だと登録できない' do
        @user.password = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end
      it 'birth_dateが空だと登録できない' do
        @user.birth_date = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Birth date can't be blank")
      end
      it 'last_nameが空だと登録できない' do
        @user.last_name = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name can't be blank")
      end
      it 'first_nameが空だと登録できない' do
        @user.first_name = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("First name can't be blank")
      end
      it 'last_name_katakanaが空だと登録できない' do
        @user.last_name_katakana = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name katakana can't be blank")
      end
      it 'first_name_katakanaが空だと登録できない' do
        @user.first_name_katakana = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("First name katakana can't be blank")
      end
      it 'emailに@マークが含まれていなければ登録できない' do
        @user.email = 'testtest.com'
        @user.valid?
        expect(@user.errors.full_messages).to include('Email is invalid')
      end
      it 'emailが重複していたら登録できない' do
        @user1 = FactoryBot.create(:user)
        another_user = FactoryBot.build(:user)
        another_user.email = @user1.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Email has already been taken')
      end
      it 'passwordが5文字以下であれば登録できない' do
        @user.password = 'aa000'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end
      it 'passwordが数字のみであれば登録できない' do
        @user.password = '000000'
        @user.password_confirmation = '000000'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password Include both letters and numbers')
      end
      it 'passwordが英字のみであれば登録できない' do
        @user.password = 'aaaaaa'
        @user.password_confirmation = 'aaaaaa'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password Include both letters and numbers')
      end
      it 'passwordとpassword_confirmationが一致しなければ登録できない' do
        @user.password_confirmation = 'aaaaa0'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it 'last_nameが全角でなければ登録できない' do
        @user.last_name = 'test'
        @user.valid?
        expect(@user.errors.full_messages).to include('Last name Full-width characters')
      end
      it 'first_nameが全角でなければ登録できない' do
        @user.first_name = 'test'
        @user.valid?
        expect(@user.errors.full_messages).to include('First name Full-width characters')
      end
      it 'last_name_katakanaが全角でなければ登録できない' do
        @user.last_name_katakana = 'test'
        @user.valid?
        expect(@user.errors.full_messages).to include('Last name katakana Full-width katakana characters')
      end
      it 'last_name_katakanaが全角でなければ登録できない' do
        @user.first_name_katakana = 'test'
        @user.valid?
        expect(@user.errors.full_messages).to include('First name katakana Full-width katakana characters')
      end
    end
  end
end
