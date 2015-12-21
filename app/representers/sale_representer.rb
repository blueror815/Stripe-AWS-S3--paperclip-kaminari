require 'roar/json/hal'

module SaleRepresenter
  include Roar::JSON::HAL

  property :id
  property :sync_uuid
  property :amount, type: BigDecimal
  property :invoice_id
  property :tax, type: BigDecimal
  property :discount, type: BigDecimal
  property :date
  property :created_at
  property :updated_at
  property :sale_type
  property :deleted_state
  property :errors
  property :show, extend: ShowRepresenter, class: Show
  property :items

  link :self do |opts|
    "#{opts[:base_url]}/sale/#{id}"
  end

  private

  def items
    items = []
    for ci in self.cart_items
      item_json = {
          quantity_in_cart: ci.quantity_in_cart,
      }
      item = ci.item
      item_json[:item] = item.extend(ItemRepresenter) if item

      items << item_json
    end

    items
  end

end