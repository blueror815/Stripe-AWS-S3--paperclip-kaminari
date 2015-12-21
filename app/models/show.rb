class Show < ActiveRecord::Base

  belongs_to :user
  belongs_to :venue
  has_many :sales

end
