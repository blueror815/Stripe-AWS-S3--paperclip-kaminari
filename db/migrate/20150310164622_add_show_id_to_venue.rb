class AddShowIdToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :show_id, :integer
  end
end
