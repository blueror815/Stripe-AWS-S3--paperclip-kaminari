class AddTrialBeganAndTrialEndedToUser < ActiveRecord::Migration
  def change
    add_column :users, :trial_began, :datetime
    add_column :users, :trial_ended, :datetime
  end
end
