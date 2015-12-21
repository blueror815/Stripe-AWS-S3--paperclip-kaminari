class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :sku
      t.integer :quantity_sold
      t.integer :quantity_on_hand
      t.decimal :price, precision: 8, scale: 2
      t.string :order_link
      t.string :nickname
      t.text :item_description
      t.string :full_name

      t.timestamps null: false
    end
  end
end
