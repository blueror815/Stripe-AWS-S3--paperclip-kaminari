require 'roar/json/hal'

module ItemRepresenter
  include Roar::JSON::HAL

  property :id
  property :sync_uuid
  property :sku
  property :quantity_sold
  property :quantity_on_hand
  property :quantity_on_road
  property :price, type: BigDecimal
  property :order_link
  property :nickname
  property :item_description
  property :full_name
  property :errors
  property :created_at
  property :updated_at
  property :image_full
  property :image_medium
  property :image_thumb
  property :deleted_state
  property :is_road_merch
  property :unit_cost, type: BigDecimal
  collection :categories

  link :self do |opts|
    "#{opts[:base_url]}/items/#{id}"
  end

  def image_full
    self.image.url
  end

  def image_medium
    self.image.url(:medium)
  end

  def image_thumb
    self.image.url(:thumb)
  end

end