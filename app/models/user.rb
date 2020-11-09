class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :buyers
  has_many :items

  NAME_REGEX_KANJI = /\A[ぁ-んァ-ン一-龥]/.freeze
  NAME_REGIX_KATAKANA = /\A[ァ-ヶー－]+\z/.freeze

  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{6,}+\z/i, message: 'Include both letters and numbers' }
  with_options presence: true do
    validates :nickname
    validates :birth_date
    validates :last_name, format: { with: NAME_REGEX_KANJI, message: 'Full-width characters' }
    validates :first_name, format: { with: NAME_REGEX_KANJI, message: 'Full-width characters' }
    validates :last_name_katakana, format: { with: NAME_REGIX_KATAKANA, message: 'Full-width katakana characters' }
    validates :first_name_katakana, format: { with: NAME_REGIX_KATAKANA, message: 'Full-width katakana characters' }
  end
end
