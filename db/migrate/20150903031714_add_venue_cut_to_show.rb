class AddVenueCutToShow < ActiveRecord::Migration
  def change
    add_column :shows, :venue_cut, :integer
  end
end
