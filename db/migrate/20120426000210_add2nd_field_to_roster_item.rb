class Add2ndFieldToRosterItem < ActiveRecord::Migration
  def self.up
    add_column :roster_items, :special_need, :string
  end

  def self.down

    remove_column :roster_items, :special_need
  end
end
