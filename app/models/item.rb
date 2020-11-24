class Item < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_one :buyer
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites
  has_many :comments

  with_options presence: true do
    validates :name
    validates :description
    validates :image
    validates :category_id, numericality: { other_than: 1, message: 'を選択してください' }
    validates :status_id, numericality: { other_than: 1, message: 'を選択してください' }
    validates :shipping_id, numericality: { other_than: 1, message: 'を選択してください' }
    validates :prefecture_id, numericality: { other_than: 1, message: 'を選択してください' }
    validates :transportday_id, numericality: { other_than: 1, message: 'を選択してください' }
    validates :price, numericality: { greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999, message: 'が設定金額の範囲外です' }
  end
  validates :price, numericality: { only_integer: true, message: 'は半角数字で入力してください' }

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :status
  belongs_to :shipping
  belongs_to :prefecture
  belongs_to :transportday
end
