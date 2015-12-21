class AddShowIdToSale < ActiveRecord::Migration
  def change
    add_column :sales, :show_id, :integer
  end
end
