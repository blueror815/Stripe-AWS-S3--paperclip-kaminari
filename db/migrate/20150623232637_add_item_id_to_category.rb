class AddItemIdToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :item_id, :integer
  end
end
