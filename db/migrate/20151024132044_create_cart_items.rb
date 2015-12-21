class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.integer :quantity_in_cart
      t.integer :item_id
      t.integer :sale_id

      t.timestamps
    end

    add_index :cart_items, :item_id
    add_index :cart_items, :sale_id
  end
end
