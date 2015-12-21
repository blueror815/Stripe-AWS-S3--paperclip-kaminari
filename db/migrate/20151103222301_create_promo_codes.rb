class CreatePromoCodes < ActiveRecord::Migration
  def change
    create_table :promo_codes do |t|
      t.string :code
      t.text :description
      t.integer :duration
      t.datetime :expiration

      t.timestamps
    end

    add_index :promo_codes, :code
  end
end
