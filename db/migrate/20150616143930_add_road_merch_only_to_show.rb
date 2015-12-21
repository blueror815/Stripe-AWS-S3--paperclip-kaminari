class AddRoadMerchOnlyToShow < ActiveRecord::Migration
  def change
    add_column :shows, :road_merch_only, :boolean
  end
end
