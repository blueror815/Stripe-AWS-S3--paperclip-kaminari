class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table  :subscriptions do |t|
      t.integer   :user_id
      t.string    :stripe_customer_id
      t.string    :stripe_subscription_id
      t.decimal   :amount
      t.date      :date
      t.date      :cancelled_at
      
      t.timestamps
    end
  end
end
