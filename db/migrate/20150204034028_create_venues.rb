class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :zip
      t.decimal :variable_fee, precision: 8, scale: 2
      t.string :state
      t.string :phone
      t.string :name
      t.decimal :management_fee, precision: 8, scale: 2
      t.decimal :fixed_fee, precision: 8, scale: 2
      t.string :email
      t.string :city
      t.string :address

      t.timestamps null: false
    end
  end
end
