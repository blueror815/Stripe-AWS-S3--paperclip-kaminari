class AddVenueIdToShows < ActiveRecord::Migration
  def change
    add_column :shows, :venue_id, :integer
  end
end
