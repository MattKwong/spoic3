class AddPaymentsToScheduledGroups < ActiveRecord::Migration
  def self.up
    add_column :scheduled_groups, :payments, :integer
  end

  def self.down
    remove_column :scheduled_groups, :payments
  end
end
