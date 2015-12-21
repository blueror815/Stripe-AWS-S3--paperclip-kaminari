class AddSyncUuidToItem < ActiveRecord::Migration
  def change
    add_column :items, :sync_uuid, :string
    add_index :items, :sync_uuid
  end
end
