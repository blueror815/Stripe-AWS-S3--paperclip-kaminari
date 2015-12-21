require 'roar/json/hal'

module ShowRepresenter
  include Roar::JSON::HAL

  property :id
  property :sync_uuid
  property :date
  property :active
  property :errors
  property :created_at
  property :updated_at
  property :deleted_state
  property :road_merch_only
  property :venue_cut
  property :user_id
  property :venue, extend: VenueRepresenter, class: Venue
  property :num_sales
  property :sales_amount
  property :total_items_sold

  link :self do |opts|
    "#{opts[:base_url]}/shows/#{id}"
  end

  collection_representer class: Show

  private

  def num_sales
    sales_data[:num]
  end

  def sales_amount
    sales_data[:amount]
  end

  def total_items_sold
    sales_data[:total_items_sold]
  end

  def sales_data
    return @sales_data if @sales_data

    @sales_data = {
        num: 0,
        amount: 0.00,
        total_items_sold: 0
    }

    Sale.where(show_id: self.id).each do |sale|
      @sales_data[:num] += 1
      @sales_data[:amount] += sale.amount
      @sales_data[:total_items_sold] += sale.cart_items.length
    end

    @sales_data
  end

end