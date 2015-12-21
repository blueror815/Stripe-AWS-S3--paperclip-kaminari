class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :first_name
      t.string :last_name
      t.string :status
      t.text :description
      t.string :phone
      t.string :email
      t.text :misc

      t.timestamps null: false
    end
  end
end
