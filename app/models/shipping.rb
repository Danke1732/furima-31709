class Shipping < ActiveHash::Base
  self.data = [
    { id: 1, type: '---' },
    { id: 2, type: '着払い(購入者負担)' },
    { id: 3, type: '送料込み(出品者負担)' }
  ]

  include ActiveHash::Associations
  has_many :items
end
