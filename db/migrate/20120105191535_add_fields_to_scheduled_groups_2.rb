class AddFieldsToScheduledGroups2 < ActiveRecord::Migration
  def self.up
    add_column :scheduled_groups, :second_payment_total, :integer
    add_column :scheduled_groups, :second_payment_date, :date
  end

  def self.down
    remove_column :scheduled_groups, :second_payment_date
    remove_column :scheduled_groups, :second_payment_total
  end
end
