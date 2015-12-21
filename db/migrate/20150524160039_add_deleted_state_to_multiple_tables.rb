class AddDeletedStateToMultipleTables < ActiveRecord::Migration

  AFFECTED_TABLES = [:carts, :categories, :customers, :items, :sales, :shows, :venues]

  def change
    AFFECTED_TABLES.each do |table|
      add_column table, :deleted_state, :boolean, default: false
    end
  end
end
