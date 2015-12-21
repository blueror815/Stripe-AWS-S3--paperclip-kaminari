class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.decimal :tax, precision: 8, scale: 2
      t.decimal :discount, precision: 8, scale: 2
      t.datetime :date
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
