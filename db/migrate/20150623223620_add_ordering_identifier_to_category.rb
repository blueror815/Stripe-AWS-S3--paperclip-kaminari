class AddOrderingIdentifierToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :ordering_identifier, :integer
  end
end
