class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :zip
      t.string :state
      t.string :phone
      t.string :last_name
      t.string :first_name
      t.string :email
      t.string :city
      t.string :address

      t.timestamps null: false
    end
  end
end
