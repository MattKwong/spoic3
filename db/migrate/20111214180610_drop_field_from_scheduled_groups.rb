class DropFieldFromScheduledGroups < ActiveRecord::Migration
  def self.up
    remove_column :scheduled_groups, :liaison_id
  end

  def self.down
    add_column :scheduled_groups, :liaison_id, :string
  end
end
