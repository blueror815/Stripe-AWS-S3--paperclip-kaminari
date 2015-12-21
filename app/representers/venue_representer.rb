require 'roar/json/hal'

module VenueRepresenter
  include Roar::JSON::HAL

  property :id
  property :name
  property :email
  property :phone
  property :address
  property :city
  property :state
  property :zip
  property :variable_fee
  property :management_fee
  property :fixed_fee
  property :created_at
  property :updated_at
  property :deleted_state
  property :contact

  link :self do |opts|
    "#{opts[:base_url]}/shows/#{show_id}/venues/#{id}"
  end
end