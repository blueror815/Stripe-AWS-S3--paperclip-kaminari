class AddStripeActiveUntilToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_active_until, :date
  end
end
