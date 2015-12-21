class User < ActiveRecord::Base

  has_secure_password validations: false

  has_one    :api_key, dependent: :destroy
  
  belongs_to :promo_code
  has_many   :subscriptions, dependent: :destroy

  has_many   :items, dependent: :destroy
  has_many   :shows, dependent: :destroy
  has_many   :sales, dependent: :destroy
  

  # Validations
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            :presence => true,
            :format => { :with => email_regex },
            :uniqueness => { :case_sensitive => false }

  validates :password,
            :presence => true,
            :length => { :minimum => 6 },
            :confirmation => true,
            :if => lambda { !password.nil? }

  def is_trial_user?
    trial_began != nil && trial_ended == nil
  end

  def is_uber_amdin?
    ['vferrer@infocusmgmt.com', 'randy@appalope.com'].include?(email)
  end

  class << self

    def trial_users(ascending=true)
      where('trial_began IS NOT NULL and trial_ended IS NULL').order(created_at: (ascending ? :asc : :desc))
    end

    def subscribed_users(ascending=true)
      where('trial_began IS NOT NULL and trial_ended IS NOT NULL OR trial_began IS NULL and trial_ended IS NULL').order(created_at: (ascending ? :asc : :desc))
    end

  end

end
