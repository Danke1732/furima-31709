class Status < ActiveHash::Base
  self.data = [
    { id: 1, type: '---' },
    { id: 2, type: '新品、未使用' },
    { id: 3, type: '未使用に近い' },
    { id: 4, type: '目立った傷や汚れなし' },
    { id: 5, type: 'やや傷や汚れあり' },
    { id: 6, type: '傷や汚れあり' },
    { id: 7, type: '全体的に状態が悪い' }
  ]

  include ActiveHash::Associations
  has_many :items
end
