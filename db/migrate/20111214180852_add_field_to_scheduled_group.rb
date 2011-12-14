class AddFieldToScheduledGroup < ActiveRecord::Migration
  def self.up
    add_column :scheduled_groups, :liaison_id, :integer
  end

  def self.down
    remove_column :scheduled_groups, :liaison_id
  end
end
