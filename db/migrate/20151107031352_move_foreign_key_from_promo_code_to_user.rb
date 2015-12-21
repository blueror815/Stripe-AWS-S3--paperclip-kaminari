class MoveForeignKeyFromPromoCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :promo_code_id, :integer
  end
end
