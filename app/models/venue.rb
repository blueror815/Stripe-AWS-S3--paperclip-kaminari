class Venue < ActiveRecord::Base

  has_many :shows, dependent: :destroy

end
