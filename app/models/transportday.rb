class Transportday < ActiveHash::Base
  self.data = [
    { id: 1, type: '---' },
    { id: 2, type: '1~2日で発送' },
    { id: 3, type: '2~3日で発送' },
    { id: 4, type: '4~7日で発送' }
  ]

  include ActiveHash::Associations
  has_many :items
end
