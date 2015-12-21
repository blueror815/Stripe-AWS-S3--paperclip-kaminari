class AddContactToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :contact, :string
  end
end
