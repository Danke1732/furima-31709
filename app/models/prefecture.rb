class Prefecture < ActiveHash::Base
  self.data = [
    {id: 1, type: '---'},
    {id: 2, type: '北海道'}, {id: 3, type: '青森県'}, {id: 4, type: '岩手県'},
    {id: 5, type: '宮城県'}, {id: 6, type: '秋田県'}, {id: 7, type: '山形県'},
    {id: 8, type: '福島県'}, {id: 9, type: '茨城県'}, {id: 10, type: '栃木県'},
    {id: 11, type: '群馬県'}, {id: 12, type: '埼玉県'}, {id: 13, type: '千葉県'},
    {id: 14, type: '東京都'}, {id: 15, type: '神奈川県'}, {id: 16, type: '新潟県'},
    {id: 17, type: '富山県'}, {id: 18, type: '石川県'}, {id: 19, type: '福井県'},
    {id: 20, type: '山梨県'}, {id: 21, type: '長野県'}, {id: 22, type: '岐阜県'},
    {id: 23, type: '静岡県'}, {id: 24, type: '愛知県'}, {id: 25, type: '三重県'},
    {id: 26, type: '滋賀県'}, {id: 27, type: '京都府'}, {id: 28, type: '大阪府'},
    {id: 29, type: '兵庫県'}, {id: 30, type: '奈良県'}, {id: 31, type: '和歌山県'},
    {id: 32, type: '鳥取県'}, {id: 33, type: '島根県'}, {id: 34, type: '岡山県'},
    {id: 35, type: '広島県'}, {id: 36, type: '山口県'}, {id: 37, type: '徳島県'},
    {id: 38, type: '香川県'}, {id: 39, type: '愛媛県'}, {id: 40, type: '高知県'},
    {id: 41, type: '福岡県'}, {id: 42, type: '佐賀県'}, {id: 43, type: '長崎県'},
    {id: 44, type: '熊本県'}, {id: 45, type: '大分県'}, {id: 46, type: '宮崎県'},
    {id: 47, type: '鹿児島県'}, {id: 48, type: '沖縄県'}
  ]

  include ActiveHash::Associations
  has_many :items
end
