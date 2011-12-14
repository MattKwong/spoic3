class AddFieldToScheduledHistories < ActiveRecord::Migration
  def self.up
    add_column :scheduled_histories, :scheduled_group_id, :integer
  end

  def self.down
    remove_column :scheduled_histories, :scheduled_group_id
  end
end
