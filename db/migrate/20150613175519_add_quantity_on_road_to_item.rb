class AddQuantityOnRoadToItem < ActiveRecord::Migration
  def change
    add_column :items, :quantity_on_road, :integer
  end
end
