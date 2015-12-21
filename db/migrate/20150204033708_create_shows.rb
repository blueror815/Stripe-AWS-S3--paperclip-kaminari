class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.datetime :date
      t.boolean :active

      t.timestamps null: false
    end
  end
end
