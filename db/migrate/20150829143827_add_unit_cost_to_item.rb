class AddUnitCostToItem < ActiveRecord::Migration
  def change
    add_column :items, :unit_cost, :decimal, precision: 8, scale: 2
  end
end
