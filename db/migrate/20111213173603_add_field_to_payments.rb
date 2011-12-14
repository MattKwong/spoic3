class AddFieldToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :scheduled_group_id, :integer
  end

  def self.down
    remove_column :payments, :scheduled_group_id
  end
end
