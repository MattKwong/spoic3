class RemoveFieldFromScheduledGroups < ActiveRecord::Migration
  def self.up
    remove_column :scheduled_groups, :payments
  end

  def self.down
    add_column :scheduled_groups, :payments, :integer
  end
end
