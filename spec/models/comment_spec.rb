require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.build(:comment)
  end

  describe 'コメント投稿機能' do
    context 'コメント投稿がうまくいくとき' do
      it 'コメントが入力されており、文字数が140文字いないであるとき' do
        expect(@comment).to be_valid
      end
    end

    context 'コメント投稿がうまくいかないとき' do
      it 'コメントが空のとき' do
        @comment.text = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('コメントを入力してください')
      end
      it 'コメントの文字数が141文字以上のとき' do
        @comment.text = '0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901'
        @comment.valid?
        expect(@comment.errors.full_messages).to include('コメントは140文字以内で入力してください')
      end
      it 'userが紐づいていないとき' do
        @comment.user = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('Userを入力してください')
      end
      it 'itemと紐づいていないとき' do
        @comment.item = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('Itemを入力してください')
      end
    end
  end
end
