class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :item

  varidates :text, presence: true
end
