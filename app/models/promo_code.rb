class PromoCode < ActiveRecord::Base

  has_many :users

  validates :code,
            :presence => true,
            length: {minimum: 6, maximum: 6},
            :uniqueness => { :case_sensitive => false }

  validates :duration, :presence => true

  validates :expiration, :presence => true

end
