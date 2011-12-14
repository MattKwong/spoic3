class RemoveFieldFromScheduledHistories < ActiveRecord::Migration
  def self.up
    remove_column :scheduled_histories, :payments
  end

  def self.down
    add_column :scheduled_histories, :payments, :integer
  end
end
