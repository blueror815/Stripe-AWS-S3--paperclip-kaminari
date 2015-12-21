require 'roar/json/hal'

module SubscriptionRepresenter
  include Roar::JSON::HAL

  property :id
  property :user_id
  property :stripe_customer_id
  property :stripe_subscription_id 
  property :amount
  property :date
  property :cancelled_at
  
  link :self do |opts|
    "#{opts[:base_url]}/subscriptions/#{id}"
  end
end