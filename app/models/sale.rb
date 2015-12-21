class Sale < ActiveRecord::Base

  belongs_to :user
  belongs_to :show
  has_many :cart_items, dependent: :destroy

end
