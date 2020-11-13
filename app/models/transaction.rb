class Transaction
  include ActiveModel::Model
  attr_accessor :postal_code, :prefecture_id, :city, :address, :building, :phone_num, :token, :user_id, :item_id

  NAME_REGEX_POSTAL = /\A\d{3}-\d{4}\z/.freeze
  NAME_REGEX_PHONE = /\A\d{,11}\z/.freeze

  with_options presence: true do
    validates :token
    validates :postal_code, format: { with: NAME_REGEX_POSTAL, message: 'Input correctly' }
    validates :prefecture_id, numericality: { other_than: 1, message: 'Select' }
    validates :city
    validates :address
    validates :phone_num, numericality: { only_integer: true, message: 'Input only number' }, format: { with: NAME_REGEX_PHONE, message: 'Within 11 digits' }
  end

  def save
    buyer = Buyer.create(user_id: user_id, item_id: item_id)
    Destination.create(postal_code: postal_code, prefecture_id: prefecture_id, city: city, address: address, building: building, phone_num: phone_num, buyer_id: buyer.id)
  end
end