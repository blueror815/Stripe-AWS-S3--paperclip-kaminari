require 'roar/json/hal'

module PromoCodeRepresenter
  include Roar::JSON::HAL

  property :id
  property :code
  property :description
  property :duration
  property :expiration
  property :expired
  # property :created_at
  # property :updated_at

  link :self do |opts|
    "#{opts[:base_url]}/pcodes/#{id}"
  end

  private

  def expired
    expiration.past?
  end

end