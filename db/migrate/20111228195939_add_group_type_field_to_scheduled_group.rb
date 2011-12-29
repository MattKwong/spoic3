class AddGroupTypeFieldToScheduledGroup < ActiveRecord::Migration
  def self.up
    add_column :scheduled_groups, :group_type_id, :integer
  end

  def self.down
    remove_column :scheduled_groups, :group_type_id
  end
end
