class AddRosterIdToScheduledGroup < ActiveRecord::Migration
  def self.up
    add_column :scheduled_groups, :roster_id, :integer
  end

  def self.down
    remove_column :scheduled_groups, :roster_id
  end
end
