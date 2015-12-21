class AddTypeAmountSyncUuidInvoiceIdToSale < ActiveRecord::Migration
  def change
    add_column :sales, :sale_type, :string
    add_column :sales, :invoice_id, :string
    add_column :sales, :sync_uuid, :string
  end
end
