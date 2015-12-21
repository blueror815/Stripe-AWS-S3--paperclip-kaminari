class AddIsRoadMerchToItem < ActiveRecord::Migration
  def change
    add_column :items, :is_road_merch, :boolean
  end
end
