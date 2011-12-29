class AddFieldToRosterItem < ActiveRecord::Migration
  def self.up
    add_column :roster_items, :roster_id, :integer
  end

  def self.down
    remove_column :roster_items, :roster_id
  end
end
