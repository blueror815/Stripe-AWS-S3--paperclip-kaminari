class UpdateVenueZipToInteger < ActiveRecord::Migration
  def change
    change_column :venues, :zip, 'integer USING CAST(zip AS integer)'
  end
end
