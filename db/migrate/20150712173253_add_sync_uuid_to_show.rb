class AddSyncUuidToShow < ActiveRecord::Migration
  def change
    add_column :shows, :sync_uuid, :string
    add_index :shows, :sync_uuid
  end
end
