class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :buyers
  has_many :items
  has_many :favorites, dependent: :destroy
  has_many :fav_items, through: :favorites, source: :item
  has_many :comments, dependent: :destroy

  attr_accessor :current_password

  NAME_REGEX_KANJI = /\A[ぁ-んァ-ン一-龥]/.freeze
  NAME_REGIX_KATAKANA = /\A[ァ-ヶー－]+\z/.freeze

  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{6,}+\z/i, message: 'は半角の数字と文字を含めてください' }, on: :create
  with_options presence: true do
    validates :nickname
    validates :birth_date
    validates :last_name, format: { with: NAME_REGEX_KANJI, message: 'は全角で入力してください' }
    validates :first_name, format: { with: NAME_REGEX_KANJI, message: 'は全角で入力してください' }
    validates :last_name_katakana, format: { with: NAME_REGIX_KATAKANA, message: 'は全角カタカナで入力してください' }
    validates :first_name_katakana, format: { with: NAME_REGIX_KATAKANA, message: 'は全角カタカナで入力してください' }
  end
end
